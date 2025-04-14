# frozen_string_literal: true

class CreateAppStoreAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :app_store_authors do |t|
      t.string :name

      t.timestamps
    end
  end
end
