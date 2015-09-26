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

  put "/user/update", to: "users#update_self", as: :self_update

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
  resources :notifications
end
