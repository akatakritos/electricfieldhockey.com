ElectricFieldHockey::Application.routes.draw do
  resources :users, :only => [:create, :show, :index]
  get 'signup', :to => 'users#new'

  resources :levels do
    match 'scoreboard', :to => 'level_wins#index'
  end

  resources :sessions, :only => [ :create, :destroy ]
  get 'signin', :to => 'sessions#new'
  delete 'signout', :to => 'sessions#destroy'

  resources :level_wins, :only => [:create]
  match 'replay/:id', :to => 'level_wins#show', :as => 'replay'

  root :to => "static_pages#index"
  match 'sample', :to => 'static_pages#sample'
  match 'tour', :to => 'static_pages#tour'

  namespace :admin do
    resources :users
    resources :levels
    get 'abingo/', :to => 'abingo_dashboard#index'
    post 'abingo/end_experiment/:id', :to => 'abingo_dashboard#end_experiment'
  end

  match '/404' => 'errors#not_found'
  match '/500' => 'errors#internal_error'

end
