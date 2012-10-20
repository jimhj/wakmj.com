Wakmj::Application.routes.draw do
  root :to => 'index#index', :as => :root

  match 'recents' => 'index#recents', :as => :recents_dramas
  match 'hots' => 'index#hots', :as => :hots_dramas

  match 'sign_in' => 'index#sign_in', :as => :sign_in, :via => [:get, :post]
  match 'sign_up' => 'index#sign_up', :as => :sign_up, :via => [:get, :post]
  match 'sign_out' => 'index#sign_out', :as => :sign_out
  match 'search' => 'index#search', :as => :search, :via => :get

  resources :tv_dramas do
    resources :downloads, :only => [:new, :create]
  end

  match 'likes' => 'likes#create', :as => :likes, :via => :post
  match 'likes' => 'likes#destroy', :as => :likes, :via => :delete

  resources :topics, :except => [:index] do
    resources :replies
  end

  resources :articles

  scope 'settings' do
    match 'avatar' => 'settings#avatar', :as => :avatar_setting, :via => [:get, :post]
    match 'account' => 'settings#account', :as => :account_setting, :via => [:get, :post]
    match 'password' => 'settings#password', :as => :password_setting, :via => [:get, :post]
  end

  namespace :cpanel do
    root :to => 'index#yesterday'
    scope 'statistics' do
      match 'yesterday' => 'index#yesterday', :as => :statistic_yesterday
      match 'today' => 'index#today', :as => :statistic_today
    end
    resources :users
    resources :miscs
  end
  
  match 'auth/weibo/callback' => 'auth#weibo_login'
  match 'auth/new_user' => 'auth#new_user', :as => :auth_new_user, :via => 'POST'

  resources :miscs, :only => :show

  resources :users, :only => [:show], :path => '' do
    member do
      get :notifications
    end
  end  

end
