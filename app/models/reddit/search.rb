# frozen_string_literal: true

module Reddit
  class Search < Search
    TABLE_COLUMNS = %w[Date Author Title Subreddit URL Upvote_Ratio].freeze
    attribute :after
    attribute :limit, :integer, default: 100
    attribute :restrict_to, :string, default: 'VeteransBenefits+Veterans'

    def client
      @client ||= Client.new
    end

    def fetch_results
      self.results = client.search(query:,
                                   restrict_to:,
                                   limit:,
                                   sort: :new,
                                   after:,
                                   start_date: start_date.beginning_of_day,
                                   end_date: end_date.end_of_day)
      self.results = results.map { |post| Post.create_from_object(post) }
    end
  end
end
