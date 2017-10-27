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

    # This function shows the view to create a new tag.
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

    # This function creates a new tag.
    def create
      @tag = LatoBlog::Tag.new(new_tag_params)

      if !@tag.save
        flash[:danger] = @tag.errors.full_messages.to_sentence
        redirect_to lato_blog.new_tag_path
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:tag_create_success]
      redirect_to lato_blog.tag_path(@tag.id)
    end

    # This function show the view to edit a tag.
    def edit
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:tags_edit])
      @tag = LatoBlog::Tag.find_by(id: params[:id])
      return unless check_tag_presence

      if @tag.meta_language != cookies[:lato_blog__current_language]
        set_current_language @tag.meta_language
      end
    end

    # This function updates a tag.
    def update
      @tag = LatoBlog::Tag.find_by(id: params[:id])
      return unless check_tag_presence

      if !@tag.update(edit_tag_params)
        flash[:danger] = @tag.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_tag_path(@tag.id)
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:tag_update_success]
      redirect_to lato_blog.tag_path(@tag.id)
    end

    # This function destroyes a tag.
    def destroy
      @tag = LatoBlog::Tag.find_by(id: params[:id])
      return unless check_tag_presence

      if !@tag.destroy
        flash[:danger] = @tag.tag_parent.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_tag_path(@tag.id)
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:tag_destroy_success]
      redirect_to lato_blog.categories_path(status: 'deleted')
    end

    private

    # This function checks the @tag variable is present and redirect to index if it not exist.
    def check_tag_presence
      if !@tag
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:tag_not_found]
        redirect_to lato_blog.tags_path
        return false
      end

      return true
    end

    # Params helpers:

    # This function generate params for a new tag.
    def new_tag_params
      # take params from front-end request
      tag_params = params.require(:tag).permit(:title).to_h
      # add current superuser id
      tag_params[:lato_core_superuser_creator_id] = @core__current_superuser.id
      # add post parent id
      tag_params[:lato_blog_tag_parent_id] = (params[:parent] && !params[:parent].blank? ? params[:parent] : generate_tag_parent)
      # add metadata
      tag_params[:meta_language] = cookies[:lato_blog__current_language]
      # return final post object
      return tag_params
    end

    # This function generate params for a edit tag.
    def edit_tag_params
      params.require(:tag).permit(:title, :lato_blog_tag_id, :meta_permalink)
    end

    # This function generate and save a new tag parent and return the id.
    def generate_tag_parent
      tag_parent = LatoBlog::TagParent.create
      return tag_parent.id
    end

  end

end
