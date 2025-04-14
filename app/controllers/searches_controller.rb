# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :set_search
  before_action :track_create, only: :create

  def new; end

  ###
  # We return with a .turbo_stream.erb in order to dynamically update the view without needing a redirect.
  # This is purely a subjective choice, we could have also redirected and still preserved the form values.
  ###

  def create
    @search.assign_attributes(search_params)
    @search.fetch_results
    respond_to(&:turbo_stream)
  end

  private

  def set_search
    @search ||= search_model.new
  end

  def search_model
    raise NotImplementedError
  end

  def search_params
    params.fetch(@search_model.model_name.param_key).permit(:query, :start_date, :end_date,
                                                            :rating)
  end

  def track_create
    ahoy.track search_model.module_parents.first.to_s, search_params.to_json
  end
end
