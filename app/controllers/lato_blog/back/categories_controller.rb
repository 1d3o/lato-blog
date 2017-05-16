module LatoBlog
  class Back::CategoriesController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # This function shows the list of possible categories.
    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:categories])
      # find categories to show
      @categories = LatoBlog::Category.where(meta_language: cookies[:lato_blog__current_language]).order('title ASC')
      @widget_index_categories = core__widgets_index(@categories, search: 'title', pagination: 10)
    end

    # This function shows a single category. It create a redirect to the edit path.
    def show
      # use edit as default post show page
      redirect_to lato_blog.edit_category_path(params[:id])
    end

    # This function shows the view to create a new category.
    def new
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:categories_new])
      @category = LatoBlog::Category.new

      if params[:language]
        set_current_language params[:language]
      end

      if params[:parent]
        @category_parent = LatoBlog::CategoryParent.find_by(id: params[:parent])
      end

      fetch_external_objects
    end

    # This function creates a new category.
    def create
      @category = LatoBlog::Category.new(new_category_params)

      if !@category.save
        flash[:danger] = @category.errors.full_messages.to_sentence
        redirect_to lato_blog.new_category_path
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:category_create_success]
      redirect_to lato_blog.category_path(@category.id)
    end

    # This function show the view to edit a category.
    def edit
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:categories_edit])
      @category = LatoBlog::Category.find_by(id: params[:id])
      return unless check_category_presence

      if @category.meta_language != cookies[:lato_blog__current_language]
        set_current_language @category.meta_language
      end

      fetch_external_objects
    end

    # This function updates a category.
    def update
      @category = LatoBlog::Category.find_by(id: params[:id])
      return unless check_category_presence

      if !@category.update(edit_category_params)
        flash[:danger] = @category.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_category_path(@category.id)
        return
      end
      
      flash[:success] = LANGUAGES[:lato_blog][:flashes][:category_update_success]
      redirect_to lato_blog.category_path(@category.id)
    end

    # This function destroyes a category.
    def destroy
      @category = LatoBlog::Category.find_by(id: params[:id])
      return unless check_category_presence

      if !@category.destroy
        flash[:danger] = @category.category_parent.errors.full_messages.to_sentence
        redirect_to lato_blog.edit_category_path(@category.id)
        return
      end
      
      flash[:success] = LANGUAGES[:lato_blog][:flashes][:category_destroy_success]
      redirect_to lato_blog.categories_path(status: 'deleted')
    end

    private

      def fetch_external_objects
        @categories_list = LatoBlog::Category.where(meta_language: cookies[:lato_blog__current_language]).where.not(
        id: @category.id).map { |cat| { title: cat.title, value: cat.id } }
      end

      # This function checks the @post variable is present and redirect to index if it not exist.
      def check_category_presence
        if !@category
          flash[:warning] = LANGUAGES[:lato_blog][:flashes][:category_not_found]
          redirect_to lato_blog.categories_path
          return false
        end

        return true
      end

      # Params helpers:

      # This function generate params for a new category.
      def new_category_params
        # take params from front-end request
        category_params = params.require(:category).permit(:title, :lato_blog_category_id).to_h
        # add current superuser id
        category_params[:lato_core_superuser_creator_id] = @core__current_superuser.id
        # add post parent id
        category_params[:lato_blog_category_parent_id] = (params[:parent] && !params[:parent].blank? ? params[:parent] : generate_category_parent)
        # add metadata
        category_params[:meta_language] = cookies[:lato_blog__current_language]
        # return final post object
        return category_params
      end

      # This function generate params for a edit category.
      def edit_category_params
        params.require(:category).permit(:title, :lato_blog_category_id)
      end

      # This function generate and save a new category parent and return the id.
      def generate_category_parent
        category_parent = LatoBlog::CategoryParent.create
        return category_parent.id
      end

  end
end
