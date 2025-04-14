# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'reddit/searches#new'
  resolve('Search') { [:search] }

  namespace :reddit do
    resource :searches, only: %i[new create]
  end

  namespace :app_store do
    resource :searches, only: %i[new create]
    resource :sentiment, only: %i[show]

    namespace :sentiments do
      resource :summaries, only: %i[show create]
    end
  end

  namespace :play_store do
    resource :searches, only: %i[new create]
    resource :sentiment, only: %i[show]

    namespace :sentiments do
      resource :summaries, only: %i[show create]
    end
  end

  resource :analytics, only: :show

  mount MissionControl::Jobs::Engine, at: '/jobs'
end
