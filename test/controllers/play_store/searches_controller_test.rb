# frozen_string_literal: true

require 'test_helper'

class PlayStore::SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # @play_store_search = play_store_searches(:one)
  end

  test 'should get new' do
    get new_play_store_searches_url
    assert_response :success

    assert_select 'va-text-input#play_store_search_query'
    assert_select 'va-select#play_store_search_rating'
    assert_select 'va-date#play_store_search_start_date'
    assert_select 'va-date#play_store_search_end_date'
    assert_select 'va-button[submit=true]'
  end

  # Last recorded 02/09/2024
  test 'should create play_store_search' do
    VCR.use_cassette('play_store_search') do
      post play_store_searches_url, as: :turbo_stream, params: {
        play_store_search: {
          query: '',
          rating: 'All',
          'start_date(1i)' => 2024,
          'start_date(2i)' => 2,
          'start_date(3i)' => 8,
          'end_date(1i)' => 2024,
          'end_date(2i)' => 2,
          'end_date(3i)' => 9
        }
      }

      assert_turbo_stream action: :update, target: 'response_play_store_search'
    end
  end
end
