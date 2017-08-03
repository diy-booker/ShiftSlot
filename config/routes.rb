Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :venues, only: [:index, :show] do
    resources :shows, only: :show
    resources :shows, shallow: true do
      resources :shifts, only: [:new, :create], shallow: true
    end
  end

  post 'users/search', to: 'users#search'


  resources :users, only: [:edit, :show, :index, :update]
  root 'landings#index'
end
