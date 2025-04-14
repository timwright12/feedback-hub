# frozen_string_literal: true

class Reddit::Author < ApplicationRecord
  attribute :name, :string
  attribute :reddit_id, :string

  has_many :submissions
  has_many :comments, class_name: 'Reddit::Comment'

  validates :reddit_id, presence: true, uniqueness: true
end
