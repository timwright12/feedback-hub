# frozen_string_literal: true

class AppStore::Author < ApplicationRecord
  attribute :name, :string

  has_many :reviews, class_name: 'AppStore::Review'

  validates :name, presence: true, uniqueness: true
end
