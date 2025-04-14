# frozen_string_literal: true

class PlayStore::SentimentsController < SentimentsController
  private

  def search_model
    PlayStore::Search
  end
end
