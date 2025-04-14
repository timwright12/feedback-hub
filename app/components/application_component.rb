# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  include Classy::Yaml::ComponentHelpers
  include Rails.application.routes.url_helpers
end
