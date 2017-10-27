module LatoBlog

  # This module contains a list of helpers used on controllers to get posts
  # to render the blog elements.
  module Interface::Queries

    # This function returns an object with the list of posts with some filters.
    def blog__get_posts(order: nil, language: nil, category_permalink: nil, category_permalink_AND: false, category_id: nil, category_id_AND: false, search: nil, page: nil, per_page: nil)
      posts = LatoBlog::Post.published.joins(:categories).joins(:post_parent).where('lato_blog_post_parents.publication_datetime <= ?', DateTime.now)

      # apply filters
      order = order && order == 'ASC' ? 'ASC' : 'DESC'
      posts = _posts_filter_by_order(posts, order)
      posts = _posts_filter_by_language(posts, language)
      posts = _posts_filter_by_category_permalink(posts, category_permalink, category_permalink_AND)
      posts = _posts_filter_category_id(posts, category_id, category_id_AND)
      posts = _posts_filter_search(posts, search)

      # take posts uniqueness
      posts = posts.uniq(&:id)

      # save total posts
      total = posts.length

      # manage pagination
      page ||= 1
      per_page ||= 20
      posts = core__paginate_array(posts, per_page, page)

      # return result
      {
        posts: posts && !posts.empty? ? posts.map(&:serialize) : [],
        page: page,
        per_page: per_page,
        order: order,
        total: total
      }
    end

    # This function returns a single post searched by id or permalink.
    def blog__get_post(id: nil, permalink: nil)
      return {} unless id || permalink

      if id
        post = LatoBlog::Post.find_by(id: id.to_i, meta_status: 'published')
      else
        post = LatoBlog::Post.find_by(meta_permalink: permalink, meta_status: 'published')
      end

      post.serialize
    end

    # This function returns an object with the list of categories with some filters.
    def blog__get_categories(order: nil, language: nil, search: nil, page: nil, per_page: nil)
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
      page ||= 1
      per_page ||= 20
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

    def _posts_filter_by_order(posts, order)
      posts.order("lato_blog_post_parents.publication_datetime #{order}")
    end

    def _posts_filter_by_language(posts, language)
      return posts unless language
      posts.where(meta_language: language)
    end

    def _posts_filter_by_category_permalink(posts, category_permalink, category_permalink_AND)
      return posts unless category_permalink
      category_permalinks = category_permalink.is_a?(Array) ? category_permalink : category_permalink.split(',')
      posts = posts.where(lato_blog_categories: { meta_permalink: category_permalinks })
      # manage AND clause
      if ['true', true].include?(category_permalink_AND)
        ids = []
        posts.pluck(:id).each do |id|
          ids.push(id) if posts.where(id: id).length >= category_permalinks.length
        end
        posts = posts.where(id: ids)
      end
      # return posts
      posts
    end

    def _posts_filter_category_id(posts, category_id, category_id_AND)
      return posts unless category_id
      category_ids = category_id.is_a?(Array) ? category_id : category_id.split(',')
      posts = posts.where(lato_blog_categories: { id: category_ids })
      # manage AND clause
      if ['true', true].include?(category_id_AND)
        ids = []
        posts.pluck(:id).each do |id|
          ids.push(id) if posts.where(id: id).length >= category_ids.length
        end
        posts = posts.where(id: ids)
      end
      # return posts
      posts
    end

    def _posts_filter_search(posts, search)
      return posts unless search
      posts.where('lato_blog_posts.title like ?', "%#{params[:search]}%")
    end

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
