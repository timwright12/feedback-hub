# frozen_string_literal: true

class CreateSubmission < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.datetime :submitted_at
      t.string :fullname

      t.timestamps
    end
  end
end
