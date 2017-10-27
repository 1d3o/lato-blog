# frozen_string_literal: true

module LatoBlog

  # Back::TagsController.
  class Back::TagsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # This function shows the list of possible tags.
    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:tags])
      # find tags to show
      @tags = LatoBlog::Tag.where(meta_language: cookies[:lato_blog__current_language]).order('title ASC')
      @widget_index_tags = core__widgets_index(@tags, search: 'title', pagination: 10)
    end

    # This function shows a single tag. It create a redirect to the edit path.
    def show
      # use edit as default post show page
      redirect_to lato_blog.edit_tag_path(params[:id])
    end

    # This function shows the view to create a new category.
    def new
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:tags_new])
      @tag = LatoBlog::Tag.new

      if params[:language]
        set_current_language params[:language]
      end

      if params[:parent]
        @tag_parent = LatoBlog::TagParent.find_by(id: params[:parent])
      end
    end

  end

end
