Rails.application.routes.draw do
  devise_for :user, :controllers => {:registrations => "user/registrations"}

  devise_scope :user do
    get 'users/new', to: 'devise/registrations/new', controller: 'user/registrations', action: 'new', as: 'sign_up'
    post '/users', to: 'devise/registrations', controller: 'user/registrations', action: 'create'
    get '*org_name/login', param: :organization, controller: 'user/sessions', action: 'new'
    get 'login', controller: 'user/sessions', action: 'new'
    post 'sessions', to: 'devise/sessions', controller: 'user/sessions', action: 'create'
  end
  resources :organizations, only: [:new, :create, :show]
  resources :venues, only: [:index, :show] do
    resources :shows, only: :show
    resources :shows, shallow: true do
      resources :shifts, only: [:new, :create, :update, :destroy, :edit]
    end
  end
  get 'shows/' => 'shows#index', as: 'calendar'
  post 'users/search', to: 'users#search'
  resources :users, only: [:edit, :show, :index, :update] do
    resources :preferred_days, only: [:update]
  end
  root 'landings#index'
  post '/shows' => 'calendars#create'
  get '/sync' => 'calendars#sync'
  get '/callback' => 'omniauths#callback'
  get '/redirect' => 'omniauths#redirect'
end
