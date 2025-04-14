# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'vcr'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  VCR.configure do |config|
    config.cassette_library_dir = 'test/vcr_cassettes'
    config.hook_into :webmock
    config.ignore_localhost = true
    config.allow_http_connections_when_no_cassette = false

    config.ignore_request do |request|
      URI(request.uri).host == 'googlechromelabs.github.io' || URI(request.uri).host == 'storage.googleapis.com'
    end

    config.default_cassette_options = {
      record: :none,
      match_requests_on: %i[method uri query]
    }
  end
end
