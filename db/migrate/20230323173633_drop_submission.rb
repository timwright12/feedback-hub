# frozen_string_literal: true

class DropSubmission < ActiveRecord::Migration[7.0]
  def change
    drop_table :submissions
  end
end
