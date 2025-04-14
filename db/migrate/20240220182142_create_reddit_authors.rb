# frozen_string_literal: true

class CreateRedditAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :reddit_authors do |t|
      t.string :name
      t.string :reddit_id

      t.timestamps
    end
  end
end
