# frozen_string_literal: true

class Sentiments::SummariesController < ApplicationController
  include Groq::Helpers
  before_action :set_markdown
  before_action :set_messages

  def show
    response = client.chat(@messages)
    conversation << { type: 'agent', content: response['content'] }
  rescue
    @error = "We hit an unexpected error. Click 'Search' to try again."
  end

  def create
    @search.assign_attributes(start_date:, end_date:)
    response = client.chat(@messages)
    conversation << { type: 'agent', content: response['content'] }
    render :show
  end

  private

  def search
    @search ||= search_model.new(start_date:, end_date:)
  end

  def client
    @client ||= Groq::Client.new(model_id: 'llama3-8b-8192')
  end

  def set_markdown
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def reviews
    @reviews ||= search
                 .fetch_results
                 .reject { |r| r.author.blank? }
                 .map { |r| [r.author.name, r.rating, r.content, r.send(search.store_updated_at)] }
  end

  def start_date
    @start_date ||= if (date = date_from_params(:start_date))
                      date.beginning_of_day
                    else
                      1.month.ago.beginning_of_month.beginning_of_day
                    end
  end

  def end_date
    @end_date ||= if (date = date_from_params(:end_date))
                    date.end_of_day
                  else
                    DateTime.now.end_of_month.end_of_day
                  end
  end

  # rubocop disable
  def set_messages
    @messages ||= [
      S('You are an analytics expert. You analyze reviews for the Vets Mobile App. You receive reviews from within
         a timeframe and provide a breakdown of key successes, failures, and suggestions that are contained from within the reviews.
         You may only reference reviews contained within the list provided, and will not create fake information.
         Do not provide any numbers.
         In each section, please provide the list of user names that you based that section off of.
         DO NOT FORGET TO INCLUDE THE USER NAMES, IT IS VITALLY IMPORTANT FOR OUR JOB.
         The reviews will come in a json array with the following format: [[user name, rating, content, date], [user name, rating, content, date]].
         You will also provide an extra section that highlights reviews that are likely to be unrelated to app performance.
         Examples of a review that is unrelated to app performance would be a complaint about a doctor, or a complaint about a facility.
         We want to be sure to know what negative reviews are outside of our control.
         Every time you reference a review, you will provide the user name of who made the review.
         Please reference the users and time of the reviews for every analysis you provide. DO NOT SYNTHESIZE DATA'),
      U('Hello! My next message will contain all of the reviews that I want analyzed.'),
      U(reviews.presence&.to_json.presence || 'Sorry, I have no reviews at this time'),
      conversation&.map do |message|
        if message[:type] == 'user'
          U(message[:content])
        elsif message[:type] == 'system'
          S(message[:content])
        else
          A(message[:content])
        end
      end
    ].reject(&:blank?).flatten
  end

  def conversation
    @conversation ||= begin
      conversation = summary_params[:conversation] || []
      conversation << { type: 'user', content: summary_params[:content] } if summary_params[:content]
      conversation
    end
  end

  def date_from_params(date_key)
    date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s) }.sort
    if date_keys.length == 1 && date_keys.first == date_key.to_s
      DateTime.parse(params[date_key])
    else
      date_array = params.values_at(*date_keys).map(&:to_i)
      Date.civil(*date_array) if date_array.present?
    end
  end

  def summary_params
    if params[:summary]
      params.fetch(:summary).permit(:content, conversation: %i[type content])
    else
      { conversation: [] }
    end
  end

  def search_model
    raise NotImplementedError
  end
end
