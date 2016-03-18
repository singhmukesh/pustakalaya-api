Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: {format: :json} do
    resources :items, only: [:index, :show, :create, :update] do
      member do
        put :change_status
      end
      collection do
        get :inactive
        get :most_rated
        get :most_leased
      end
    end
    resources :books, only: [] do
      collection do
        get :available
      end
    end
    resources :leases, only: [:index, :create] do
      collection do
        post :return
      end
    end
    resources :watches, only: [:create] do
      collection do
        post :unwatch
      end
    end
    resources :users, only: [] do
      collection do
        get :info
        get :leases
        get :watches
        get :ranking
      end
    end
    resources :categories, only: [:index]
    resources :ratings, only: [:create]
    resources :reviews, only: [:create]
    resources :authors, only: [:index]
    resources :session, only: [] do
      collection do
        post :login
      end
    end
  end

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
  mount Sidekiq::Web, at: "/sidekiq"
end
