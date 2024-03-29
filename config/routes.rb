Rails.application.routes.draw do
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, only: [:sessions, :registrations, :passwords]
  resources :questions, only: [:edit, :new, :create, :index, :show, :update, :destroy]
  resources :answers, only: [:edit, :new, :create, :update]
  resources :question_viewers, only: [:create]
  resources :upvotes, only: [:create, :destroy]
  resources :downvotes, only: [:create, :destroy]

  resources :references, only: [:show] do
    collection do
      post :search
    end
  end

  post 'send_weekly_email' => 'jobs#send_weekly_email'

  # Defines the root path route ("/")
  root 'pages#home'
end
