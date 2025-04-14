# frozen_string_literal: true

class Reddit::Comment < ApplicationRecord
  include PgSearch::Model
  multisearchable against: %i[title body]

  attribute :title, :string
  attribute :body, :string
  attribute :url, :string
  attribute :reddit_id, :string
  attribute :upvotes, :integer
  attribute :downvotes, :integer
  attribute :subreddit, :string
  attribute :reddit_created_at, :datetime

  belongs_to :author, class_name: 'Reddit::Author'
  belongs_to :listing, polymorphic: true, touch: true

  has_many :comments, as: :listing, dependent: :destroy

  validates :reddit_id, presence: true, uniqueness: true

  before_create :set_url

  ###
  # This cache will bust every time either the comment or the comment's comments are updated.
  # We do this through the 'touch: true' attribute on the 'belongs_to' association.
  ###

  def comment_count
    Rails.cache.fetch("#{cache_key}/comment_count") do
      count = 0

      comments.each do |comment|
        count += 1
        comment.comments.each do |_sub_comment|
          count += 1

          count += comment.comment_count if comment.comments
        end
      end

      count
    end
  end

  private

  def set_url
    submission = listing
    submission = submission.listing until submission.is_a?(Reddit::Submission)

    regex = Regexp.new("^.*#{submission.reddit_id}")
    self.url = "#{submission.url.match(regex)}/comment/#{reddit_id}"
  end
end
