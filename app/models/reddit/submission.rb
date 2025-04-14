# frozen_string_literal: true

class Reddit::Submission < ApplicationRecord
  include PgSearch::Model
  multisearchable against: %i[title body]

  attribute :title, :string
  attribute :body, :string
  attribute :url, :string
  attribute :media_embed, :string
  attribute :reddit_id, :string
  attribute :upvotes, :integer
  attribute :downvotes, :integer
  attribute :subreddit, :string
  attribute :reddit_created_at, :datetime

  belongs_to :author, class_name: 'Reddit::Author'
  has_many :comments, as: :listing, dependent: :destroy

  validates :reddit_id, presence: true, uniqueness: true
  validates :reddit_created_at, presence: true, uniqueness: true

  ###
  # This cache will bust every time either the post or the posts's comments are updated.
  # We do this through the 'touch: true' attribute on the comment's 'has_many' association.
  ###

  def comment_count
    Rails.cache.fetch("#{cache_key}/comment_count") do
      count = 0

      comments.each do |comment|
        count += 1
        count += comment.comment_count
      end

      count
    end
  end
end
