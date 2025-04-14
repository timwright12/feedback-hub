# frozen_string_literal: true

class CreateRedditSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :reddit_submissions do |t|
      t.string :title
      t.string :body
      t.string :url
      t.belongs_to :author
      t.string :media_embed
      t.string :reddit_id
      t.integer :upvotes
      t.integer :downvotes

      t.timestamps
    end
  end
end
