namespace :api do

  # posts
  get 'posts', to: 'posts#index', as: 'posts_index'
  get 'post', to: 'posts#show', as: 'posts_show'

  # categories
  get 'categories', to: 'categories#index', as: 'categories_index'
  get 'category', to: 'categories#show', as: 'categories_show'

  # tags
  get 'tags', to: 'tags#index', as: 'tags_index'
  get 'tag', to: 'tags#show', as: 'tags_show'

end
