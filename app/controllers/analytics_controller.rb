# frozen_string_literal: true

class AnalyticsController < ApplicationController
  def show
    set_chart_data
  end

  private

  def start_date
    @start_date ||= (params[:start_date] || DateTime.now - 1.week).to_date
  end

  def end_date
    @end_date ||= (params[:end_date] || DateTime.now).to_date
  end

  def set_chart_data
    @chart_data = {}

    (start_date..end_date).each do |date|
      %w[Reddit AppStore PlayStore].each do |source|
        date_data = { [source, date] => ahoy_events[[source, date]].to_i }
        @chart_data.merge! date_data
      end
    end
  end

  def ahoy_events
    @ahoy_events ||= Ahoy::Event
                     .where(name: %w[Reddit
                                     AppStore
                                     PlayStore])
                     .where(time: start_date.beginning_of_day..end_date.end_of_day)
                     .group(:name)
                     .group_by_day(:time)
                     .count
  end
end
