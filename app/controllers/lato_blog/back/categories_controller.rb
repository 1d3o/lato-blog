module LatoBlog
  class Back::CategoriesController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # This function shows the list of possible categories.
    def index

    end
    
  end
end
