# frozen_string_literal: true

require 'application_system_test_case'

class Reddit::SearchesTest < ApplicationSystemTestCase
  test 'can search and download csv' do
    VCR.use_cassette('reddit_search') do
      visit new_reddit_searches_path

      within find('va-text-input#reddit_search_query').shadow_root do
        find('input').set('app')
      end

      select_date('va-date#reddit_search_start_date', '2024-02-06')
      select_date('va-date#reddit_search_end_date', '2024-02-07')

      find('va-button[submit=true]').click

      sleep 2
      assert_selector 'button', text: 'Download as .csv'

      find('button', text: 'Download as .csv').click
      sleep 2
      downloaded_file = Dir[File.join(Capybara.save_path, 'reddit-search-results*.csv')]&.first
      assert File.exist?(downloaded_file), 'File was not downloaded'
      File.delete(downloaded_file) if File.exist?(downloaded_file)
    end
  end
end
