# frozen_string_literal: true

class SentimentsController < ApplicationController
  def show
    set_monthly_average_chart_data
    set_chart_data_rolling_average
    set_chart_data_non_average
  end

  private

  def set_monthly_average_chart_data
    @monthly_average_chart_data = monthly_hash

    reviews.each do |review|
      @monthly_average_chart_data[review.send(search.store_updated_at).strftime('%B %Y')][:sum] += review.rating
      @monthly_average_chart_data[review.send(search.store_updated_at).strftime('%B %Y')][:count] += 1
    end

    @monthly_average_chart_data.transform_values! do |values|
      values[:count].zero? ? 0 : (values[:sum].to_f / values[:count]).round(2)
    end
  end

  def monthly_hash
    monthly_hash = {}
    current_month = start_date.to_date.beginning_of_month

    while current_month <= end_date.to_date.end_of_month
      monthly_hash[current_month.strftime('%B %Y')] = { sum: 0, count: 0 }
      current_month = current_month.next_month
    end

    monthly_hash
  end

  def set_chart_data_rolling_average
    @rolling_average_chart_data = {}

    previous_ratings = []
    current_average = 0.0

    (start_date.to_date..end_date.to_date).each do |date|
      reviews = reviews_for_date(date).map(&:rating)

      if reviews.present?
        previous_ratings += reviews
        current_average = (previous_ratings.sum.to_f / previous_ratings.length).round(2)
      end

      @rolling_average_chart_data[['Rolling Average Rating', date]] = current_average
    end
  end

  def set_chart_data_non_average
    @non_average_chart_data = {}

    (start_date.to_date..end_date.to_date).each do |date|
      (1..5).each do |star|
        @non_average_chart_data[["#{star} Star", date]] = 0
      end
    end

    reviews.each do |review|
      @non_average_chart_data[["#{review.rating} Star", review.send(search.store_updated_at).to_date]] += 1
    end
  end

  def search
    @search ||= search_model.new(start_date:, end_date:)
  end

  def reviews
    @reviews ||= search.fetch_results
  end

  def start_date
    @start_date ||= if params[:start_date] && (date = Date.strptime(params[:start_date], '%Y-%m-%d'))
                      date.beginning_of_day
                    else
                      1.month.ago.beginning_of_month.beginning_of_day
                    end
  end

  def end_date
    @end_date ||= if params[:end_date] && (date = Date.strptime(params[:end_date], '%Y-%m-%d'))
                    date.end_of_day
                  else
                    DateTime.now.end_of_day
                  end
  end

  def reviews_for_date(date)
    reviews.select { |review| review.send(search.store_updated_at).to_date == date }
  end

  def search_model
    raise NotImplementedError
  end
end
