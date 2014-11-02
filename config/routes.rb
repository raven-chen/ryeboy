Tao::Application.routes.draw do
  resources :replies, :except => [:index, :show, :new]

  resources :topics

  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'users#profile'

  resources :users, :except => [:destroy] do
    member do
      put :assign_my_tasks
    end
  end

  resources :exercises do
    collection do
      get :my
      get :unfinished
      post :like
    end
  end

  resources :comments do
    collection do
      get :received
    end
  end

  resources :documents, :only => [:index, :show]
  resources :groups, :only => [:index, :show]
  resources :fines
  resources :fund_exchange_activities, :only => [:index, :show]
  resources :user_activities, :only => [:index, :show]
  resources :tasks, :only => [:index, :show] do
    collection do
      get :common
    end
  end
end
