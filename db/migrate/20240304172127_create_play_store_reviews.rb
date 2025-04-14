# frozen_string_literal: true

class CreatePlayStoreReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :play_store_reviews do |t|
      t.string :title
      t.string :body
      t.integer :rating
      t.belongs_to :author
      t.string :link
      t.datetime :play_store_updated_at
      t.string :content
      t.string :version
      t.integer :vote_count
      t.string :app_id

      t.timestamps
    end
  end
end
