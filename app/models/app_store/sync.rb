# frozen_string_literal: true

module AppStore
  class Sync
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveRecord::AttributeAssignment

    def client
      @client ||= Client.new
    end

    def sync_reviews(app_id:, start_date: Date.today, end_date: Date.today, force_sync: false)
      (start_date.to_datetime..end_date.to_datetime).each do |date|
        if force_sync || should_sync_date?(date)
          Rails.logger.info 'Forcing sync; skipping sync date check...' if force_sync
          runner = Runner.create(source: :app_store, start_date: date.beginning_of_day, end_date: date.end_of_day)
          runner.end_date = DateTime.now if date == Date.today
          sync_submissions(app_id:, date:)
          runner.update(completed: true)
        end
      end
    end

    private

    def should_sync_date?(date)
      !Runner.synced_date?(date:, source: :app_store)
    end

    # rubocop:disable Metrics/AbcSize
    def sync_submissions(app_id:, date: Date.today)
      Rails.logger.info 'AppStoreSyncJob: syncing reviews.'
      existing_reviews = AppStore::Review
                         .includes(:author)
                         .where(app_store_updated_at: date.beginning_of_day..date.end_of_day)
                         .order(:app_store_updated_at)

      client.search(app_id:, start_date: date.beginning_of_day, end_date: date.end_of_day).each do |review|
        Rails.logger.info "Adding/Updating review for #{review.author.name} posted at #{review.posted_date}"
        review.app_id = app_id
        existing_review = existing_reviews.find { |r| r.author&.name == review.author.name }
        existing_review ? existing_review.update(review.attributes) : review.save
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
