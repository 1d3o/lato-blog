module LatoBlog

  # This module contains a list of functions used to manage categories for the blog.
  module Interface::Categories

    # This function create the default category if it not exists.
    def blog__create_default_category
      category_parent = LatoBlog::CategoryParent.find_by(meta_default: true)
      return if category_parent

      category_parent = LatoBlog::CategoryParent.new(meta_default: true)
      throw 'Impossible to create default category parent' unless category_parent.save

      languages = blog__get_languages_identifier
      languages.each do |language|
        category = LatoBlog::Category.new(
          title: 'Default',
          meta_permalink: "default_#{language}",
          meta_language: language,
          lato_core_superuser_creator_id: 1,
          lato_blog_category_parent_id: category_parent.id
        )
        throw 'Impossible to create default category' unless category.save
      end
    end

    # This function cleans all old category parents without any child.
    def blog__clean_category_parents
      category_parents = LatoBlog::CategoryParent.all
      category_parents.map { |cp| cp.destroy if cp.categories.empty? }
    end

    # This function returns an object with the list of categories with some filters.
    def blog__get_categories(
      order: nil,
      language: nil,
      search: nil,
      page: nil,
      per_page: nil
    )
      categories = LatoBlog::Category.all

      # apply filters
      order = order && order == 'ASC' ? 'ASC' : 'DESC'
      categories = _categories_filter_by_order(categories, order)
      categories = _categories_filter_by_language(categories, language)
      categories = _categories_filter_search(categories, search)

      # take categories uniqueness
      categories = categories.uniq(&:id)

      # save total categories
      total = categories.length

      # manage pagination
      page = page&.to_i || 1
      per_page = per_page&.to_i || 20
      categories = core__paginate_array(categories, per_page, page)

      # return result
      {
        categories: categories && !categories.empty? ? categories.map(&:serialize) : [],
        page: page,
        per_page: per_page,
        order: order,
        total: total
      }
    end

    # This function returns a single category searched by id or permalink.
    def blog__get_category(id: nil, permalink: nil)
      return {} unless id || permalink

      if id
        category = LatoBlog::Category.find_by(id: id.to_i)
      else
        category = LatoBlog::Category.find_by(meta_permalink: permalink)
      end

      category.serialize
    end

    private

    def _categories_filter_by_order(categories, order)
      categories.order("title #{order}")
    end

    def _categories_filter_by_language(categories, language)
      return categories unless language
      categories.where(meta_language: language)
    end

    def _categories_filter_search(categories, search)
      return categories unless search
      categories.where('title like ?', "%#{search}%")
    end

  end
end
