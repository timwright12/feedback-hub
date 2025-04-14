# frozen_string_literal: true

class AppStoreSyncJob < ApplicationJob
  queue_as :background
  limits_concurrency to: 1, key: ->(app_id: '1559609596', **) { app_id }

  def perform(app_id: '1559609596', start_date: (Date.today - 2.days).beginning_of_day,
              end_date: (Date.today - 2.days).end_of_day, force_sync: false)
    Rails.logger.info "Starting AppStoreSyncJob with range: #{start_date} - #{end_date}"
    sync = AppStore::Sync.new
    sync.sync_reviews(app_id:, start_date:, end_date:, force_sync:)
  end
end
