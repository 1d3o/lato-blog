# main routes
get 'switch_current_language', to: 'back/back#switch_current_language', as: 'switch_current_language'

# posts
resources :posts, module: 'back'
post 'posts_extra/update_status', to: 'back/posts#update_status', as: 'posts_update_status'
post 'posts_extra/update_publication_datetime', to: 'back/posts#update_publication_datetime', as: 'posts_update_publication_datetime'
post 'posts_extra/update_categories', to: 'back/posts#update_categories', as: 'posts_update_categories'
post 'posts_extra/update_seo_description', to: 'back/posts#update_seo_description', as: 'posts_update_seo_description'
get 'posts_extra/destroy_all_deleted', to: 'back/posts#destroy_all_deleted', as: 'posts_destroy_all_deleted'

# post fields
resources :post_fields, module: 'back', only: [:index, :destroy]
post 'post_fields_extra/create_relay_field', to: 'back/post_fields#create_relay_field', as: 'post_fields_create_relay_field'
post 'post_fields_extra/destroy_relay_field', to: 'back/post_fields#destroy_relay_field', as: 'post_fields_destroy_relay_field'

# categories
resources :categories, module: 'back'

# tags
resources :tags, module: 'back'