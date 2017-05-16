module LatoBlog
  class Back::CategoriesController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # This function shows the list of possible categories.
    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:categories])
      @categories = LatoBlog::Category.all
      @widget_index_categories = core__widgets_index(@categories, pagination: 10)
    end

    # This function shows a single category. It create a redirect to the edit path.
    def show
      # use edit as default post show page
      redirect_to lato_blog.edit_category_path(params[:id])
    end
    
  end
end
