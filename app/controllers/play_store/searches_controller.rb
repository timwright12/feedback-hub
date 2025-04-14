# frozen_string_literal: true

class PlayStore::SearchesController < SearchesController
  # def new
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
