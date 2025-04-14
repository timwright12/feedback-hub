# frozen_string_literal: true

Groq.configure do |config|
  config.api_key = Rails.application.credentials.dig(:groq, :api_key)
  config.model_id = 'llama3-8b-8192'
end
