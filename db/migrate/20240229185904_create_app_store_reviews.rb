# frozen_string_literal: true

class CreateAppStoreReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :app_store_reviews do |t|
      t.string :title
      t.string :body
      t.integer :rating
      t.belongs_to :author
      t.string :link
      t.datetime :app_store_updated_at
      t.string :content
      t.string :version
      t.integer :vote_count
      t.integer :vote_sum
      t.string :app_id

      t.timestamps
    end
  end
end
