# frozen_string_literal: true

class CreateRedditComments < ActiveRecord::Migration[7.0]
  def change
    create_table :reddit_comments do |t|
      t.string :title
      t.string :body
      t.belongs_to :author
      t.string :reddit_id
      t.string :permalink
      t.belongs_to :listing, polymorphic: true
      t.integer :upvotes
      t.integer :downvotes

      t.timestamps
    end
  end
end
