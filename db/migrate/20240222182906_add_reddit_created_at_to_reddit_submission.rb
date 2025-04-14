# frozen_string_literal: true

class AddRedditCreatedAtToRedditSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :reddit_submissions, :reddit_created_at, :datetime
  end
end
