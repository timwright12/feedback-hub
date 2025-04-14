# frozen_string_literal: true

class AddSubredditToRedditSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :reddit_submissions, :subreddit, :string
  end
end
