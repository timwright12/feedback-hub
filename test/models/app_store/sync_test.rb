# frozen_string_literal: true

require 'test_helper'

class AppStore::SyncTest < ActiveSupport::TestCase
  setup do
    @runner = runners(:app_store_runner)
    # @app_store_search = app_store_searches(:one)
  end

  test 'should use database cache' do
    sync = AppStore::Sync.new

    assert_no_difference -> { AppStore::Review.count } do
      sync.sync_reviews(app_id: '1559609596', start_date: DateTime.parse('2024-02-08'),
                        end_date: DateTime.parse('2024-02-08 23:59:59'))
    end
  end

  test 'should use database cache and live data' do
    sync = AppStore::Sync.new

    assert_difference 'AppStore::Review.count', 3 do
      VCR.use_cassette('app_store_search') do
        sync.sync_reviews(app_id: '1559609596', start_date: DateTime.parse('2024-02-07'),
                          end_date: DateTime.parse('2024-02-08 23:59:59'))
      end
    end
  end
end
