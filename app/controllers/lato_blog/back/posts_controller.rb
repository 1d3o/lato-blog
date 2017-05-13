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

      if params[:language]
        set_current_language params[:language]
      end

      if params[:parent]
        @post_parent = LatoBlog::PostParent.find_by(id: params[:parent])
      end
    end

    # This function creates a new post.
    def create
      @post = LatoBlog::Post.new(new_post_params)

      if !@post.save
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
    end

    # This function updates a post.
    def update
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      if !@post.update(edit_post_params)
        flash[:danger] = @post.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end
      
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

      if !@post.update(meta_status: params[:status])
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

      if !params[:publication_datetime]
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_publication_datetime_not_accepted]
        redirect_to lato_blog.edit_post_path(@post.id)
        return false
      end

      if !@post.post_parent.update(publication_datetime: params[:publication_datetime])
        flash[:danger] = @post.post_parent.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_post_path(@post.id)
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_update_success]
      redirect_to lato_blog.post_path(@post.id)    
    end 
    
    # This function destroyes a post.
    def destroy
      @post = LatoBlog::Post.find_by(id: params[:id])
      return unless check_post_presence

      if !@post.destroy
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

      if !@posts || @posts.length < 1
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:deleted_posts_not_found]
        redirect_to lato_blog.posts_path(status: 'deleted')
        return
      end

      @posts.each do |post|
        if !post.destroy
          flash[:danger] = post.errors.full_messages.to_sentence
          redirect_to lato_blog.edit_post_path(post.id)
          return
        end
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:deleted_posts_destroy_success]
      redirect_to lato_blog.posts_path(status: 'deleted')
    end

    private

      # This function checks the @post variable is present and redirect to index if it not exist.
      def check_post_presence
        if !@post
          flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_not_found]
          redirect_to lato_blog.posts_path
          return false
        end

        return true
      end

      # Params helpers:

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
        return post_params
      end

      # This function generate params for a edit post.
      def edit_post_params
        params.require(:post).permit(:title, :subtitle, :content, :excerpt)
      end

      # This function generate and save a new post parent and return the id.
      def generate_post_parent
        post_parent = LatoBlog::PostParent.create
        return post_parent.id
      end
    
  end
end
