Gatepass::Engine.routes.draw do
  get 'authentication/login'
  get 'authentication/logout'
  post 'authentication/authenticate'
  resources :users
end
