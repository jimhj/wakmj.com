Wakmj::Application.routes.draw do
  root :to => 'index#index', :as => :root
  match 'sign_in' => 'index#sign_in', :as => :sign_in, :via => [:get, :post]
  match 'sign_up' => 'index#sign_up', :as => :sign_up, :via => :get
  match 'sign_out' => 'index#sign_out', :as => :sign_out

  resources :tv_dramas

  match 'likes' => 'likes#create', :as => :likes, :via => :post
  match 'likes' => 'likes#destroy', :as => :likes, :via => :delete

  resources :topics, :except => [:index] do
    resources :replies
  end

  resources :users, :except => [:index]

  scope 'settings' do
    match 'avatar' => 'settings#avatar', :as => :avatar_setting
    match 'account' => 'settings#account', :as => :account_setting, :via => [:get, :post]
  end

end
