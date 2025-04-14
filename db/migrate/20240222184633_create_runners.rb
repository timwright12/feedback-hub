# frozen_string_literal: true

class CreateRunners < ActiveRecord::Migration[7.0]
  def change
    create_table :runners do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :completed
      t.integer :source

      t.timestamps
    end
  end
end
