# frozen_string_literal: true

class PlayStore::Author < ApplicationRecord
  attribute :name, :string

  has_many :reviews, class_name: 'PlayStore::Review'

  validates :name, presence: true, uniqueness: true
end
