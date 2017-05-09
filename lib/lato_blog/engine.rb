module LatoBlog
  class Engine < ::Rails::Engine
    isolate_namespace LatoBlog

    require 'rubygems'

    # add routes support
    initializer 'Add gem routes to application', before: :load_config_initializers do
      Rails.application.routes.append do
        mount LatoBlog::Engine, at: '/lato/blog'
      end
    end

  end
end
