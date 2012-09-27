Wakmj::Application.routes.draw do
  root :to => 'index#index', :as => :root
  match 'sign_in' => 'index#sign_in', :as => :sign_in, :via => [:get, :post]
  match 'sign_up' => 'index#sign_up', :as => :sign_up, :via => [:get, :post]

  resources :tv_dramas
  resources :topics, :except => [:index]

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
