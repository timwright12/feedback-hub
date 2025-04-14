# frozen_string_literal: true

require 'rest-client'

module PlayStore
  class Client
    SORT = {
      newest: 2,
      rating: 3,
      helpfulness: 1
    }.freeze

    LANG = {
      en: 'en'
    }.freeze

    COUNTRY = {
      us: 'us'
    }.freeze

    def search(app_id:, start_date:, end_date:, sort: :newest, number_of_reviews_per_request: 100, token: nil,
               reviews: [])
      request_body = if token
                       paginated_form_body(sort:, number_of_reviews_per_request:, app_id:,
                                           token:)
                     else
                       initial_form_body(
                         sort:, number_of_reviews_per_request:, app_id:
                       )
                     end
      response = RestClient.post(url, request_body)
      ugly_data = JSON.parse(sanitize_body(response.body))
      pretty_data = ugly_data.first.third.present? ? JSON.parse(ugly_data.first.third) : []
      token = token(pretty_data) unless pretty_data.blank?
      reviews += Array.wrap(pretty_data[0]).map { |entry| Review.from_json(entry, link_base(app_id:)) }

      if reviews.to_a.blank? || reviews.last.play_store_updated_at < start_date
        reviews.select { |review| review.play_store_updated_at > start_date && review.play_store_updated_at < end_date }
      else
        search(app_id:,
               start_date:,
               end_date:,
               token:,
               reviews:)
      end
    end

    private

    def url(lang: :en, country: :us)
      "https://play.google.com/_/PlayStoreUi/data/batchexecute?rpcids=qnKhOb&f.sid=-697906427155521722&bl=boq_playuiserver_20190903.08_p0&hl=#{LANG[lang]}&gl=#{COUNTRY[country]}&authuser&soc-app=121&soc-platform=1&soc-device=1&_reqid=1065213"
    end

    def initial_form_body(sort:, number_of_reviews_per_request:, app_id:)
      "f.req=%5B%5B%5B%22UsvDTd%22%2C%22%5Bnull%2Cnull%2C%5B2%2C#{SORT[sort]}%2C%5B#{number_of_reviews_per_request}%2Cnull%2Cnull%5D%2Cnull%2C%5B%5D%5D%2C%5B%5C%22#{app_id}%5C%22%2C7%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D"
    end

    def paginated_form_body(sort:, number_of_reviews_per_request:, app_id:, token:)
      "f.req=%5B%5B%5B%22UsvDTd%22%2C%22%5Bnull%2Cnull%2C%5B2%2C#{SORT[sort]}%2C%5B#{number_of_reviews_per_request}%2Cnull%2C%5C%22#{token}%5C%22%2Cnull%5D%2Cnull%2C%5B%5D%5D%2C%5B%5C%22#{app_id}%5C%22%2C7%5D%5D%22%2Cnull%2C%22generic%22%5D%5D%5D"
    end

    def link_base(app_id:)
      "https://play.google.com/store/apps/details?id=#{app_id}&reviewId="
    end

    def token(response)
      response[1][1]
    end

    def sanitize_body(response)
      response.gsub(/^.*?\n\n/, '')
    end
  end
end
