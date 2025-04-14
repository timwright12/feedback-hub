# frozen_string_literal: true

class AddRedditCreatedAtToRedditComment < ActiveRecord::Migration[7.0]
  def change
    add_column :reddit_comments, :reddit_created_at, :datetime
  end
end
