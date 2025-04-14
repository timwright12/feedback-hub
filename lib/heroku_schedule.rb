# frozen_string_literal: true

# Run script for Heroku Scheduler

Runner.where(created_at: 1.days.ago...).destroy_all

AppStoreSyncJob.perform_now
PlayStoreSyncJob.perform_now
