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
  #resources :teams, concerns: :taskable

  get 'teams/:team_id/tasks', to: 'tasks#index_team'
  get 'users/:user_id/tasks', to: 'tasks#index_user', as: 'my_tasks'
  resources :tasks
  
  

end