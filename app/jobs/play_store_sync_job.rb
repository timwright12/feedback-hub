# frozen_string_literal: true

class PlayStoreSyncJob < ApplicationJob
  queue_as :background
  limits_concurrency to: 1, key: ->(app_id: 'gov.va.mobileapp', **) { app_id }

  def perform(app_id: 'gov.va.mobileapp', start_date: (Date.today - 2.days).beginning_of_day,
              end_date: (Date.today - 2.days).end_of_day, force_sync: false)
    Rails.logger.info "Starting PlayStoreSyncJob with range: #{start_date} - #{end_date}"
    sync = PlayStore::Sync.new
    sync.sync_reviews(app_id:, start_date:, end_date:, force_sync:)
  end
end
