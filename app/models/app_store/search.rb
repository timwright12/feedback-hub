# frozen_string_literal: true

module AppStore
  class Search < Search
    TABLE_COLUMNS = %w[Date Version Author Rating Title Content URL].freeze
    attribute :rating, :integer, default: 0

    def client
      @client ||= Client.new
    end

    def review_model
      AppStore::Review
    end

    def store_updated_at
      :app_store_updated_at
    end

    # def fetch_results
    #   super
    # end
  end
end
