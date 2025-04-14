# frozen_string_literal: true

module PlayStore
  class Search < Search
    TABLE_COLUMNS = %w[Date Version Author Rating Review Content URL].freeze

    attribute :rating, :integer, default: 0

    def client
      @client ||= Client.new
    end

    def review_model
      PlayStore::Review
    end

    def store_updated_at
      :play_store_updated_at
    end

    # def fetch_results
    #   super
    # end
  end
end
