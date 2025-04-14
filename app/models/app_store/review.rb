# frozen_string_literal: true

class AppStore::Review < ApplicationRecord
  include PgSearch::Model
  multisearchable against: %i[title content]
  attribute :app_store_updated_at, :datetime
  attribute :rating, :integer
  attribute :version, :string
  attribute :title, :string
  attribute :content, :string
  attribute :link, :string
  attribute :vote_count, :integer
  attribute :vote_sum, :integer

  belongs_to :author, class_name: 'AppStore::Author'
  validates :author, presence: true

  def self.create_from_json(json)
    review = new(app_store_updated_at: json['updated']['label'],
                 rating: json['im:rating']['label'],
                 version: json['im:version']['label'],
                 title: json['title']['label'],
                 content: json['content']['label'],
                 link: json['link']['attributes']['href'],
                 vote_count: json['im:voteCount']['label'],
                 vote_sum: json['im:voteSum']['label'])
    review.build_author(name: json['author']['name']['label'])
    review
  end

  def author_name
    author&.name
  end

  def posted_date
    app_store_updated_at
  end
end
