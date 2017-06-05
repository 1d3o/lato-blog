namespace :api do

  get 'posts', to: 'posts#index', as: 'posts_index'
  get 'post', to: 'posts#show', as: 'posts_show'

end