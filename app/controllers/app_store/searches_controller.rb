# frozen_string_literal: true

class AppStore::SearchesController < SearchesController
  # def new
  #   super
  # end

  # def create
  #   super
  # end

  private

  def search_model
    @search_model ||= AppStore::Search
  end
end
