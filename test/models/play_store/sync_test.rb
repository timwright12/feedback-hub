# frozen_string_literal: true

require 'test_helper'

class PlayStore::SyncTest < ActiveSupport::TestCase
  setup do
    @runner = runners(:app_store_runner)
    # @app_store_search = app_store_searches(:one)
  end

  test 'should use database cache' do
    sync = PlayStore::Sync.new

    assert_no_difference -> { PlayStore::Review.count } do
      sync.sync_reviews(app_id: 'gov.va.mobileapp', start_date: DateTime.parse('2024-02-08'),
                        end_date: DateTime.parse('2024-02-08 23:59:59'))
    end
  end

  test 'should use database cache and live data' do
    sync = PlayStore::Sync.new

    assert_difference 'PlayStore::Review.count', 5 do
      VCR.use_cassette('play_store_search') do
        sync.sync_reviews(app_id: 'gov.va.mobileapp', start_date: DateTime.parse('2024-02-07'),
                          end_date: DateTime.parse('2024-02-08 23:59:59'))
      end
    end
  end
end
