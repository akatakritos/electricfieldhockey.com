ElectricFieldHockey::Application.routes.draw do
  resources :users, :only => [:create, :show, :index]

  resources :levels do
    match 'scoreboard', :to => ':evelWins#index'
  end

  resources :sessions, :only => [ :create, :destroy ]

  resources :level_wins, :only => [:create]

  match 'replay/:id', :to => 'LevelWins#show', :as => 'replay'

  root :to => "static_pages#index"
  match 'sample', :to => 'static_pages#sample'
  match 'tour', :to => 'static_pages#tour'
  post 'background', :to => 'backgrounds#create'

  get 'signin', :to => 'Sessions#new'
  delete 'signout', :to => 'Sessions#destroy'

  get 'signup', :to => 'Users#new'

  namespace :admin do
    resources :users
  end
end
