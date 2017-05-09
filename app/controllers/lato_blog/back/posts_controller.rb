module LatoBlog
  class Back::PostsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:posts])
    end
    
  end
end
