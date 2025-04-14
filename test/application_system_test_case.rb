# frozen_string_literal: true

require 'test_helper'
require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/shadowdom'

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
  # Chromedriver 77 requires setting this for headless mode on linux
  # Different versions of Chrome/selenium-webdriver require setting differently - jus set them all
  browser_options.add_preference('download.default_directory', Capybara.save_path)
  browser_options.add_preference(:download, default_directory: Capybara.save_path)

  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  driver_options = { browser: :chrome, timeout: 30 }.tap do |opts|
    opts[options_key] = browser_options
  end

  Capybara::Selenium::Driver.new(app, **driver_options).tap do |driver|
    # Set download dir for Chrome < 77
    driver.browser.download_path = Capybara.save_path
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  driven_by :selenium_chrome_headless, using: :chrome, screen_size: [1400, 1400]

  include Capybara::DSL
  include Capybara::Minitest::Assertions

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def select_date(web_component_selector, value)
    date = DateTime.parse(value)

    within find(web_component_selector).shadow_root do
      within find('va-text-input.input-year').shadow_root do
        find('input').set(date.year)
      end

      within find('va-select.select-month').shadow_root do
        find('select').find(:option, text: date.strftime('%B')).select_option
      end

      within find('va-select.select-day').shadow_root do
        find('select').find(:option, text: date.strftime('%-d'), exact_text: true).select_option
      end
    end
  end
end
