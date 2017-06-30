module LatoBlog
  class Back::PostsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # This function shows the list of published posts.
    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:posts])
      # find correct status to show
      @posts_status = 'published'
      @posts_status = 'drafted' if params[:status] && params[:status] === 'drafted'
      @posts_status = 'deleted' if params[:status] && params[:status] === 'deleted'
      # find informations data
      @posts_informations = {
        published_length: LatoBlog::Post.published.where(meta_language: cookies[:lato_blog__current_language]).length,
        drafted_length: LatoBlog::Post.drafted.where(meta_language: cookies[:lato_blog__current_language]).length,
        deleted_length: LatoBlog::Post.deleted.where(meta_language: cookies[:lato_blog__current_language]).length
      }
      # find posts to show
      @posts = LatoBlog::Post.where(meta_status: @posts_status,
      meta_language: cookies[:lato_blog__current_language]).joins(:post_parent).order('lato_blog_post_parents.publication_datetime DESC')

      @widget_index_posts = core__widgets_index(@posts, search: 'title', pagination: 10)
    end

    # This function shows a single post. It create a redirect to the edit path.
    def show
      # use edit as default post show page
      redirect_to lato_blog.edit_post_path(params[:id])
    end

    # This function shows the view to create a new post.
    def new
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:posts_new])
      @post = LatoBlog::Post.new

      set_current_language params[:language] if params[:language]

      if params[:parent]
        @post_parent = LatoBlog::PostParent.find_by(id: params[:parent])
      end

      fetch_external_objects
    end

    # This function creates a new post.
    def create
      @post = LatoBlog::Post.new(new_post_params)

      unless @post.save
        flash[:danger] = @post.errors.full_messages.to_sentence
        redirect_to lato_blog.new_post_path
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_create_success]
      redirect_to lato_blog.post_path(@post.id)
    end

    # This function show the view to edit a post.
    def edit
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:posts_edit])
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      if @post.meta_language != cookies[:lato_blog__current_language]
        set_current_language @post.meta_language
      end

      fetch_external_objects
    end

    # This function updates a post.
    def update
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      # check post data update
      unless @post.update(edit_post_params)
        flash[:danger] = @post.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end

      # update single fields
      unless update_fields
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_update_fields_warning]
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end

      # render positive response
      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_update_success]
      redirect_to lato_blog.post_path(@post.id)
    end

    # This function updates the status of a post.
    def update_status
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      if !params[:status] || !BLOG_POSTS_STATUS.values.include?(params[:status])
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_status_not_accepted]
        redirect_to lato_blog.edit_post_path(@post.id)
        return false
      end

      unless @post.update(meta_status: params[:status])
        flash[:danger] = @post.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_update_success]
      redirect_to lato_blog.post_path(@post.id)
    end

    # This function updates the publication datetime of a post (update the post parent).
    def update_publication_datetime
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      unless params[:publication_datetime]
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_publication_datetime_not_accepted]
        redirect_to lato_blog.edit_post_path(@post.id)
        return false
      end

      unless @post.post_parent.update(publication_datetime: params[:publication_datetime])
        flash[:danger] = @post.post_parent.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_update_success]
      redirect_to lato_blog.post_path(@post.id)
    end

    # This function updates the categories of a post.
    def update_categories
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      unless params[:categories]
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_categories_not_accepted]
        redirect_to lato_blog.edit_post_path(@post.id)
        return false
      end

      params[:categories].each do |category_id, value|
        category = LatoBlog::Category.find_by(id: category_id)
        next if !category || category.meta_language != @post.meta_language

        category_post = LatoBlog::CategoryPost.find_by(lato_blog_post_id: @post.id, lato_blog_category_id: category.id)
        if value == 'true'
          LatoBlog::CategoryPost.create(lato_blog_post_id: @post.id, lato_blog_category_id: category.id) unless category_post
        else
          category_post.destroy if category_post
        end
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_update_success]
      redirect_to lato_blog.post_path(@post.id)
    end

    # This function destroyes a post.
    def destroy
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      unless @post.destroy
        flash[:danger] = @post.post_parent.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_destroy_success]
      redirect_to lato_blog.posts_path(status: 'deleted')
    end

    # Tis function destroyes all posts with status deleted.
    def destroy_all_deleted
      @posts = LatoBlog::Post.deleted

      if !@posts || @posts.empty?
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:deleted_posts_not_found]
        redirect_to lato_blog.posts_path(status: 'deleted')
        return
      end

      @posts.each do |post|
        unless post.destroy
          flash[:danger] = post.errors.full_messages.to_sentence
          redirect_to lato_blog.edit_post_path(post.id)
          return
        end
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:deleted_posts_destroy_success]
      redirect_to lato_blog.posts_path(status: 'deleted')
    end

    # Private functions:
    # **************************************************************************

    private

    def fetch_external_objects
      @categories = LatoBlog::Category.all.where(meta_language: cookies[:lato_blog__current_language])
      @medias = LatoMedia::Media.all
    end

    # This function checks the @post variable is present and redirect to index if it not exist.
    def check_post_presence
      if !@post
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_not_found]
        redirect_to lato_blog.posts_path
        return false
      end

      true
    end

    # Update fields helpers:
    # **************************************************************************

    # This function checks all fields params and update the value
    # on the database for the field.
    def update_fields
      return true unless params[:fields] 
      params[:fields].each do |id, value|
        field = @post.post_fields.find_by(id: id)
        return false unless field
        return false unless update_field(field, value)
      end
      true
    end

    # This function updates a single field from its key and value.
    def update_field(field, value)
      case field.typology
      when 'text'
        update_field_text(field, value)
      when 'datetime'
        update_field_datetime(field, value)
      when 'editor'
        update_field_editor(field, value)
      when 'geolocalization'
        update_field_geolocalization(field, value)
      when 'image'
        update_field_image(field, value)
      when 'composed'
        update_field_composed(field, value)
      when 'relay'
        update_field_relay(field, value)
      end
    end

    # Update specific fields helpers:
    # **************************************************************************

    # Text.
    def update_field_text(field, value)
      field.update(value: value)
    end

    # Datetime.
    def update_field_datetime(field, value)
      field.update(value: value)
    end

    # Editor.
    def update_field_editor(field, value)
      field.update(value: value)
    end

    # Geolocalization.
    def update_field_geolocalization(field, value)
      final_value = {
        lat: value[:lat],
        lng: value[:lng],
        address: value[:address]
      }
      field.update(value: final_value)
    end

    # Image.
    def update_field_image(field, value)
      field.update(value: value)
    end

    # Composed.
    def update_field_composed(field, value)
      # find composed children
      child_fields = field.post_fields.visibles
      # loop values and update single children
      value.each do |child_id, child_value|
        child_field = child_fields.find_by(id: child_id)
        return false unless child_field
        return false unless update_field(child_field, child_value)
      end
      true
    end

    # Relay.
    def update_field_relay(field, value)
      # find composed children
      child_fields = field.post_fields.visibles
      # loop values and update single children
      value.each do |child_id, child_value|
        if child_id.include?('position')
          child_id = child_id.dup
          child_id.slice! 'position'
          return false unless update_field_relay_single_position(child_id, child_value, child_fields)
        else
          return false unless update_field_relay_single_value(child_id, child_value, child_fields)
        end
      end
      true
    end

    def update_field_relay_single_value(id, value, child_fields)
      child_field = child_fields.find_by(id: id)
      return false unless child_field
      update_field(child_field, value)
    end

    def update_field_relay_single_position(id, value, child_fields)
      child_field = child_fields.find_by(id: id)
      return false unless child_field
      child_field.update(position: value)
    end

    # Params helpers:
    # **************************************************************************

    # This function generate params for a new post.
    def new_post_params
      # take params from front-end request
      post_params = params.require(:post).permit(:title, :subtitle).to_h
      # add current superuser id
      post_params[:lato_core_superuser_creator_id] = @core__current_superuser.id
      # add post parent id
      post_params[:lato_blog_post_parent_id] = (params[:parent] && !params[:parent].blank? ? params[:parent] : generate_post_parent)
      # add metadata
      post_params[:meta_language] = cookies[:lato_blog__current_language]
      post_params[:meta_status] = BLOG_POSTS_STATUS[:drafted]
      # return final post object
      post_params
    end

    # This function generate params for a edit post.
    def edit_post_params
      params.require(:post).permit(:meta_permalink, :title, :subtitle, :content, :excerpt)
    end

    # This function generate and save a new post parent and return the id.
    def generate_post_parent
      post_parent = LatoBlog::PostParent.create
      post_parent.id
    end

  end
end
