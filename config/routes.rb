Tao::Application.routes.draw do
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'users#profile'

  resources :users, :except => [:destroy]

  resources :exercises do
    collection do
      get :my
    end
  end

  resources :documents, :only => [:index, :show]
  resources :groups, :only => [:index, :show]
  resources :fines, :only => [:index, :show]
  resources :fund_exchange_activities, :only => [:index, :show]
  resources :user_activities, :only => [:index, :show]
  resources :tasks, :only => [:index, :show]
end
