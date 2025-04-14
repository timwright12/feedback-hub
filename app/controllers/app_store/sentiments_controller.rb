# frozen_string_literal: true

class AppStore::SentimentsController < SentimentsController
  # def show
  #   super
  # end

  private

  def search_model
    AppStore::Search
  end
end
