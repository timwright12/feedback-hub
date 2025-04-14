# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  def links
    [
      {
        href: new_reddit_searches_path,
        text: 'Reddit'
      },
      {
        href: new_app_store_searches_path,
        text: 'App Store'
      },
      {
        href: new_play_store_searches_path,
        text: 'Play Store'
      }
    ]
  end
end
