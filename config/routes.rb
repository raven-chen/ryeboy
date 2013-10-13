Tao::Application.routes.draw do
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'users#profile'

  post "/users/add_to_my_task" => "users#add_to_my_tasks", :as => :add_to_my_tasks

  resources :users, :only => [:index, :show]
  resources :exercises

  resources :documents, :only => [:index, :show]
  resources :groups, :only => [:index, :show]
  resources :fines, :only => [:index, :show]
  resources :fund_exchange_activities, :only => [:index, :show]
  resources :user_activities, :only => [:index, :show]
  resources :tasks, :only => [:index, :show]
end
