# main routes
get 'dashboard', to: 'back/dashboard#index', as: 'dashboard'

# posts 
resources :posts