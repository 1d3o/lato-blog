module LatoBlog
  class Back::CategoriesController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # This function shows the list of possible categories.
    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:categories])
      @categories = get_categories_orders_by_relations
      @widget_index_categories = core__widgets_index(@categories, pagination: 10)
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
    end

    private

      # List order functions:

      # This function return all categories ordered by the relations between themself.
      def get_categories_orders_by_relations
        orders_categories = []
        categories = LatoBlog::Category.all
        parent_categories = categories.where(lato_blog_category_id: nil).order('created_at DESC')

        parent_categories.each do |parent_category|
          orders_categories.push(parent_category)
          orders_categories = orders_categories + get_tree_for_category(parent_category, categories)
        end
        
        return orders_categories
      end

      def get_tree_for_category category, categories
        tree = []
        children = categories.where(lato_blog_category_id: category.id).order('created_at DESC')

        children.each do |child|
          tree.push(child)
          tree = tree + get_tree_for_category(child, categories)
        end
        
        return tree
      end
    
  end
end
