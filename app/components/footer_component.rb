# frozen_string_literal: true

class FooterComponent < ApplicationComponent
  def links
    [
      {
        href: analytics_path,
        text: 'Analytics'
      },
      {
        href: 'https://github.com/department-of-veterans-affairs/va-mobile-app',
        text: 'For more info: VA Mobile on GitHub',
        aria: { label: 'External Link: Visit the VA mobile app GitHub repository' }
      }
    ]
  end
end
