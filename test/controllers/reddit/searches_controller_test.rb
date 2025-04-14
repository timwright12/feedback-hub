# frozen_string_literal: true

require 'test_helper'

class Reddit::SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # @reddit_search = reddit_searches(:one)
  end

  test 'should get new' do
    get new_reddit_searches_url
    assert_response :success

    assert_select 'va-text-input#reddit_search_query'
    assert_select 'va-date#reddit_search_start_date'
    assert_select 'va-date#reddit_search_end_date'
    assert_select 'va-button[submit=true]'
  end

  # Last recorded 02/09/2024
  test 'should create reddit_search' do
    VCR.use_cassette('reddit_search') do
      post reddit_searches_url, as: :turbo_stream, params: {
        reddit_search: {
          query: 'app',
          'start_date(1i)' => 2024,
          'start_date(2i)' => 5,
          'start_date(3i)' => 23,
          'end_date(1i)' => 2024,
          'end_date(2i)' => 5,
          'end_date(3i)' => 24
        }
      }

      assert_turbo_stream action: :update, target: 'response_reddit_search'
    end
  end
end
