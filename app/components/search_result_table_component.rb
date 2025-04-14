# frozen_string_literal: true

class SearchResultTableComponent < ApplicationComponent
  attr_reader :search

  def initialize(search:)
    @search = search
  end

  def header_classes(name)
    if @search.class::TABLE_COLUMNS.include?(name)
      'relative px-3 py-3.5 text-left'
    else
      'hidden'
    end
  end

  def row_classes(name)
    if @search.class::TABLE_COLUMNS.include?(name)
      'whitespace-wrap px-3 py-4 text-sm'
    else
      'hidden'
    end
  end

  def source
    @search.class.name.split('::').first.underscore.dasherize
  end
end
