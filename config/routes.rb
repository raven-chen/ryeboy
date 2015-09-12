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
      put :reset_password
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

  resources :comments

  resources :documents, :only => [:index, :show]
  resources :posts
  resources :user_activities, :only => [:index, :show]
  resources :tasks, :except => [:destroy]
end
