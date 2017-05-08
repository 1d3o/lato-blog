module LatoBlog
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def index
      redirect_to lato_blog.dashboard_path
    end

  end
end
