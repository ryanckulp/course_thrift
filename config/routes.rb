Rails.application.routes.draw do
  get 'courses/index'
  get 'courses/new'
  root 'pages#home'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'signup' }
  get 'logout', to: 'pages#logout', as: 'logout'

  resources :subscribe, only: [:index]
  resources :dashboard, only: [:index]
  resources :account, only: [:index, :update]
  resources :billing_portal, only: [:create]
  match '/billing_portal' => 'billing_portal#create', via: [:get]
  match '/cancel' => 'billing_portal#destroy', via: [:get]

  # static pages
  pages = %w(
    privacy terms
  )

  pages.each do |page|
    get "/#{page}", to: "pages##{page}", as: "#{page.gsub('-', '_')}"
  end

  resources :courses, only: [:index, :new, :create, :update, :show]
  get 'browse', to: 'courses#index'

  resources :listings, only: [:new, :edit, :index, :create, :update, :destroy]
  get 'list', to: 'listings#new'
  get "listings/sold/:code", to: 'listings#sold', as: 'listing_sold'

  # admin panels
  authenticated :user, -> user { user.admin? } do
    namespace :admin do
      resources :dashboard, only: [:index]
      resources :impersonations, only: [:new]
      resources :users, only: [:edit, :update, :destroy]
    end

    # convenience helper
    get 'admin', to: 'admin/dashboard#index'
  end
end
