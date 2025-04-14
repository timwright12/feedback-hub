# frozen_string_literal: true

require 'application_system_test_case'

class PlayStore::SearchesTest < ApplicationSystemTestCase
  test 'can search and download csv' do
    VCR.use_cassette('play_store_search') do
      visit new_play_store_searches_path

      within find('va-text-input#play_store_search_query').shadow_root do
        find('input').set('app')
      end

      select_date('va-date#play_store_search_start_date', '2024-02-06')
      select_date('va-date#play_store_search_end_date', '2024-02-07')

      find('va-button[submit=true]').click

      assert_selector 'button', text: 'Download as .csv'

      find('button', text: 'Download as .csv').click
      sleep 2
      downloaded_file = Dir[File.join(Capybara.save_path, 'play-store-search-results*.csv')]&.first
      assert_not_nil downloaded_file
      assert File.exist?(downloaded_file), 'File was not downloaded'
      File.delete(downloaded_file) if File.exist?(downloaded_file)
    end
  end
end
