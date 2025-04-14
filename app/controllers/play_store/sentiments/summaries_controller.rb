# frozen_string_literal: true

class PlayStore::Sentiments::SummariesController < Sentiments::SummariesController
  include Groq::Helpers

  # def show
  #   super
  # end

  # def create
  #   super
  # end

  private

  def search_model
    @search_model ||= PlayStore::Search
  end
end
