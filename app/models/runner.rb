# frozen_string_literal: true

###
# The Runner is responsible for keeping track of what times have already been synced with for various sources.
# This is necessary because we cannot depend on the Reddit Post's and/or App Store/Play Store dates to be proof of ALL of
# a specific day's data being synced. This is because the recurring jobs may fail to run, we may allow manual syncing, or we may
# accidentally run the job before the day is over.
# The `synced_date?` method is responsible for checking if a specific date has already been synced with for a specific source
# by checking that every second of a day has been accounted for by a Runner. If a second is not accounted for, then we know that
# the day has not been fully synced with.
###

class Runner < ApplicationRecord
  attribute :start_date, :datetime
  attribute :end_date, :datetime
  attribute :completed, :boolean
  enum :source, %i[reddit app_store play_store]

  def self.synced_date?(date:, source:)
    seconds_in_day = Set.new(date.beginning_of_day.to_i..date.end_of_day.to_i)

    where(start_date: date.beginning_of_day..date.end_of_day)
      .or(Runner.where(end_date: date.beginning_of_day..date.end_of_day))
      .where(source:, completed: true).each do |runner|
      (runner.start_date.to_i..runner.end_date.to_i).each do |second|
        seconds_in_day.delete(second)
      end
    end

    seconds_in_day.empty?
  end
end
