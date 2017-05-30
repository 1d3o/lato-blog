namespace :doc do

  root 'doc#index'

  # fields
  get 'fields_text', to: 'fields#text', as: 'fields_text'

end