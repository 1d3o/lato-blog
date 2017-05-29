module LatoBlog

  # ApplicationController
  class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception

    def index
      redirect_to lato_blog.posts_path
    end

  end
end
