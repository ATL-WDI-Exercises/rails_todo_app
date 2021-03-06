Rails.application.routes.draw do

  root to: 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'about', to: 'static_pages#about', as: 'about'

  resources :todos
  get 'todos/:id/toggle_completed', to: 'todos#toggle_completed', as: 'toggle'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
