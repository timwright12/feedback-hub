# frozen_string_literal: true

class RedditSyncJob < ApplicationJob
  queue_as :background
  limits_concurrency to: 1, key: ->(subreddit:) { subreddit }, group: 'reddit_sync'

  def perform(subreddit:, start_date: Date.today.beginning_of_day, end_date: Date.today.end_of_day)
    sync = Reddit::Sync.new
    sync.sync_subreddit(subreddit:, start_date:, end_date:)
  end
end
