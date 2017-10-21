Rails.application.routes.draw do

  get "/browse" => "asciicasts#index", :as => :browse
  get "/browse/:category" => "asciicasts#index", :as => :category

  get '/a/:id.js' => redirect(ActionController::Base.helpers.asset_path("widget.js"), status: 302)

  resources :asciicasts, path: 'a' do
    member do
      get '/raw' => 'asciicasts#embed' # legacy route, probably no longer used anywhere
      get :embed
      get :example
    end
  end

  get "/u/:id" => "users#show", as: :unnamed_user
  get "/~:username" => "users#show", as: :public_profile

  get "/oembed" => "oembed#show", as: :oembed

  get "/login/new" => redirect("/not-gonna-happen"), as: :new_login # define new_login_path
  get "/logout" => "sessions#destroy"

  # GitLab
  if GITLAB_ENABLED
    get '/auth/:provider/callback' => 'sessions#create'
    get '/auth/failure' => 'sessions#failure'
    get '/signin' => 'sessions#new', :as => :signin
    get '/signout' => 'sessions#destroy', :as => :signout
  end

  resources :api_tokens, only: [:destroy]

  resource :user

  resource :username do
    get :skip
  end

  root 'home#show'

  get '/about' => 'pages#show', page: :about, as: :about
  get '/privacy' => 'pages#show', page: :privacy, as: :privacy
  get '/tos' => 'pages#show', page: :tos, as: :tos
  get '/contributing' => 'pages#show', page: :contributing, as: :contributing
  get '/contact' => 'pages#show', page: :contact, as: :contact

end
