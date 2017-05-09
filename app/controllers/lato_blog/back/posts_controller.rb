module LatoBlog
  class Back::PostsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    def index

    end
    
  end
end
