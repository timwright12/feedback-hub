# frozen_string_literal: true

class AddSubredditToRedditComment < ActiveRecord::Migration[7.0]
  def change
    add_column :reddit_comments, :subreddit, :string
  end
end
