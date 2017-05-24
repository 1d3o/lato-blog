# main routes
get 'switch_current_language', to: 'back/back#switch_current_language', as: 'switch_current_language'

# posts 
resources :posts, module: 'back'
post 'posts_extra/update_status', to: 'back/posts#update_status', as: 'posts_update_status'
post 'posts_extra/update_publication_datetime', to: 'back/posts#update_publication_datetime', as: 'posts_update_publication_datetime'
post 'posts_extra/update_categories', to: 'back/posts#update_categories', as: 'posts_update_categories'
get 'posts_extra/destroy_all_deleted', to: 'back/posts#destroy_all_deleted', as: 'posts_destroy_all_deleted'

# categories
resources :categories, module: 'back'