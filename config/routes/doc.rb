namespace :doc do

  root 'doc#index'

  get 'fields_text', to: 'fields#text', as: 'fields_text'
  get 'fields_editor', to: 'fields#editor', as: 'fields_editor'
  get 'fields_geolocalization', to: 'fields#geolocalization', as: 'fields_geolocalization'
  get 'fields_image', to: 'fields#image', as: 'fields_image'
  get 'fields_composed', to: 'fields#composed', as: 'fields_composed'
  get 'fields_relay', to: 'fields#relay', as: 'fields_relay'

end