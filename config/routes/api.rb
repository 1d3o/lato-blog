namespace :api do

  # posts
  get 'posts', to: 'posts#index', as: 'posts_index'
  get 'post', to: 'posts#show', as: 'posts_show'

  # categories
  get 'categories', to: 'categories#index', as: 'categories_index'
  get 'category', to: 'categories#show', as: 'categories_show'

end
