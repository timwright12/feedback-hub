# frozen_string_literal: true

class Reddit::SearchesController < SearchesController
  # def new
  #   super
  # end

  # def create
  #   super
  # end

  private

  def search_model
    @search_model ||= Reddit::Search
  end
end
