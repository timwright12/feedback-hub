# frozen_string_literal: true

class PlayStore::Review < ApplicationRecord
  include PgSearch::Model
  multisearchable against: %i[title content]

  attribute :author_name, :string
  attribute :play_store_updated_at, :datetime
  attribute :rating, :integer
  attribute :version, :string
  attribute :title, :string
  attribute :content, :string
  attribute :link, :string
  attribute :vote_count, :integer

  belongs_to :author, class_name: 'PlayStore::Author'
  validates :author, presence: true

  # Attribute mapping were found through https://github.com/facundoolano/google-play-scraper/blob/main/lib/reviews.js
  def self.from_json(json, link_base)
    review = new(play_store_updated_at: generate_date(json[5]),
                 rating: json[2],
                 version: json[10],
                 title: json[0],
                 content: json[4],
                 link: link_base + json[0],
                 vote_count: json[6])
    review.build_author(name: json[1][0])
    review
  end

  def self.generate_date(date_array)
    milliseconds_last_digits = date_array[1]&.to_s || '000'
    milliseconds_total = "#{date_array[0]}#{milliseconds_last_digits[0...3]}".to_i
    Time.at(milliseconds_total / 1000)
  end

  def author_name
    author&.name
  end

  def posted_date
    play_store_updated_at
  end
end
