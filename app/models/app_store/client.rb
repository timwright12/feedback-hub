# frozen_string_literal: true

require 'rest-client'

module AppStore
  class Client
    BASE_URL = 'https://itunes.apple.com/us/rss/customerreviews'

    def search(app_id:, start_date:, end_date:, url: "#{BASE_URL}/id=#{app_id}/sortBy=mostRecent/json",
               reviews: [])
      response = RestClient.get(url)
      data = JSON.parse(response)
      next_url = data['feed']['link'].find do |link|
        link['attributes']['rel'] == 'next'
      end['attributes']['href'].gsub('xml', 'json')
      new_reviews = data['feed']['entry'].map { |entry| Review.create_from_json(entry) }
      reviews += new_reviews

      if reviews.to_a.blank? || reviews.last.app_store_updated_at < start_date || next_url == url
        reviews.select { |review| review.app_store_updated_at > start_date && review.app_store_updated_at < end_date }
      else
        search(app_id:,
               start_date:,
               end_date:,
               url: next_url,
               reviews:)
      end
    end
  end
end
