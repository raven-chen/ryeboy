Tao::Application.routes.draw do
  mount Rich::Engine => '/rich', :as => 'rich'

  resources :replies, :except => [:index, :show, :new]

  resources :topics

  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'users#profile'

  resources :users, :except => [:destroy] do
    member do
      get :new_tag
      post :add_tag
      put :assign_my_tasks
      get :change_password
      put :update_password
    end
  end

  resources :images, only: [:create]

  resources :exercises do
    collection do
      get :my
      get :unfinished
      post :like
      post :dislike
      get :review
    end
  end

  resources :comments do
    collection do
      get :received
    end
  end

  resources :documents, :only => [:index, :show]
  resources :posts, :only => [:index, :show]
  resources :user_activities, :only => [:index, :show]
  resources :tasks, :only => [:index, :show] do
    collection do
      get :common
    end
  end
end
