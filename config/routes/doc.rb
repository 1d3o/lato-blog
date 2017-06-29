namespace :doc do

  root 'doc#index'

  get 'fields_text', to: 'fields#text', as: 'fields_text'
  get 'fields_image', to: 'fields#image', as: 'fields_image'
  get 'fields_composed', to: 'fields#composed', as: 'fields_composed'

end