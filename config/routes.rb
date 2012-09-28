Wakmj::Application.routes.draw do
  root :to => 'index#index', :as => :root
  match 'sign_in' => 'index#sign_in', :as => :sign_in, :via => [:get, :post]
  match 'sign_up' => 'index#sign_up', :as => :sign_up, :via => [:get, :post]

  resources :tv_dramas
  resources :topics, :except => [:index]
  resources :users, :except => [:index]

end
