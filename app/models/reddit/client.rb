# frozen_string_literal: true

require 'redd'

module Reddit
  class Client
    def search(query:, restrict_to:, limit:, after:, start_date:, end_date:, sort: :new, submissions: []) # rubocop:disable Metrics/ParameterLists
      results = session.search(query,
                               restrict_to:,
                               limit:,
                               sort:,
                               after:)

      submissions += results.to_a

      if results.to_a.blank? || submissions.last.created_at < start_date
        submissions.select do |submission|
          submission.created_at > start_date && submission.created_at < end_date
        end
      else
        search(query:,
               restrict_to:,
               limit:,
               after: submissions.last.name,
               start_date:,
               end_date:,
               submissions:)
      end
    end

    def session
      @session ||= Redd.it(Rails.application.credentials.reddit)
    end
  end
end
