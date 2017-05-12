# main routes
get 'switch_current_language', to: 'back/back#switch_current_language', as: 'switch_current_language'

# posts 
resources :posts, module: 'back'
post 'posts_extra/update_status', to: 'back/posts#update_status', as: 'posts_update_status'
get 'posts_extra/destroy_all_deleted', to: 'back/posts#destroy_all_deleted', as: 'posts_destroy_all_deleted'