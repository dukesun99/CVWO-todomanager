Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  #concern :taskable do 
  #  resources :tasks
  #end

  resources :users
  resources :teams

  get 'teams/:team_id/tasks', to: 'tasks#index_team', as: 'team_tasks'
  get 'users/:user_id/tasks', to: 'tasks#index_user', as: 'my_tasks'
  get 'users/:user_id/teams', to: 'teams#index_user', as: 'my_teams'
  get 'teams/:team_id/join', to: 'teams#apply_team', as: 'apply_team'
  post 'teams/:team_id/join', to:'teams#add_user'
  get 'teams/:team_id/members', to: 'teams#index_member', as: 'team_members'
  resources :tasks
  
  

end