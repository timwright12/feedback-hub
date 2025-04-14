# frozen_string_literal: true

class Search
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :query, :string, default: ''
  attribute :start_date, :date, default: Date.today
  attribute :end_date, :date, default: Date.today
  attribute :results, array: true, default: []

  def client
    raise NotImplementedError
  end

  def review_model
    raise NotImplementedError
  end

  def store_updated_at
    raise NotImplementedError
  end

  ###
  # We are only searching the database, not "Live" data. We have SolidQueue set up in order to automatically scrape
  # data on a recurring basis. In order to see that process, look at the `app/jobs` directory. In order to view the
  # recurring schedule, looks at the `config/solid_queue.yml` file.
  ###
  def fetch_results
    reviews = review_model.includes(:author)

    if query.present?
      reviews = reviews.where(id: PgSearch.multisearch(query).where(searchable_type: review_model.to_s).pluck(:searchable_id))
    end

    reviews = reviews.where(rating:) if rating.to_i != 0

    reviews =
      reviews.where("#{store_updated_at} >= ? AND #{store_updated_at} <=?", start_date.beginning_of_day,
                    end_date.end_of_day)

    self.results = reviews
  end
end
