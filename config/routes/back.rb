# main routes
get 'switch_current_language', to: 'back/back#switch_current_language', as: 'switch_current_language'

# posts 
resources :posts, module: 'back'