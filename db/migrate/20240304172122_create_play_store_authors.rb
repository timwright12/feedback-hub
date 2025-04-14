# frozen_string_literal: true

class CreatePlayStoreAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :play_store_authors do |t|
      t.string :name

      t.timestamps
    end
  end
end
