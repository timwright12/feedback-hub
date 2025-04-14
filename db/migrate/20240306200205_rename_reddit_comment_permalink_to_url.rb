# frozen_string_literal: true

class RenameRedditCommentPermalinkToUrl < ActiveRecord::Migration[7.0]
  def change
    rename_column :reddit_comments, :permalink, :url
  end
end
