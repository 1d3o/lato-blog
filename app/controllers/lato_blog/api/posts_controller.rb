module LatoBlog
  class Api::PostsController < Api::ApiController

    def index
      posts = LatoBlog::Post.published.joins(:categories).joins(:post_parent)
      posts = posts.where('lato_blog_post_parents.publication_datetime <= ?', DateTime.now)

      # order posts
      order = (params[:order] && params[:order] == 'ASC') ? 'ASC' : 'DESC'
      posts = posts.order("lato_blog_post_parents.publication_datetime #{order}")

      # filter language
      posts = filter_language(posts) if params[:language]
      # filter category permalink
      posts = filter_category_permalink if params[:category_permalink]
      # filter category id
      posts = filter_category_id if params[:category_id]
      # filter search
      posts = posts.where('lato_blog_posts.title like ?', "%#{params[:search]}%") if params[:search]

      # take posts uniqueness
      posts = posts.uniq(&:id)

      # save total posts
      total = posts.length

      # manage pagination
      page = params[:page] ? params[:page].to_i : 1
      per_page = params[:per_page] ? params[:per_page].to_i : 20
      posts = core__paginate_array(posts, per_page, page)

      # render response
      core__send_request_success(
        posts: (posts && !posts.empty?) ? posts.map(&:serialize) : [],
        page: page,
        per_page: per_page,
        order: order,
        total: total
      )
    end

    def show
      # check parameters
      core__send_request_fail('Uncorrect parameters') && return unless params[:id] || params[:permalink]

      # find post
      if params[:id]
        post = LatoBlog::Post.find_by(id: params[:id].to_i, meta_status: 'published')
      else
        post = LatoBlog::Post.find_by(meta_permalink: params[:permalink], meta_status: 'published')
      end

      # render respnse
      core__send_request_fail('Post not found') && return unless post
      core__send_request_success(post: post.serialize)
    end

    private

    def filter_language(posts)
      return unless params[:language]
      languages = params[:language].is_a?(Array) ? params[:language] : params[:language].split(',')
      query_array(posts, :meta_language, languages)
    end

    def filter_category_permalink(posts)
      return unless params[:category_permalink]
      category_permalinks = params[:category_permalink].is_a?(Array) ? params[:category_permalink] : params[:category_permalink].split(',')
      query_nested_array(posts, :lato_blog_categories, :meta_permalink, category_permalinks)
    end

    def filter_category_id(posts)
      return unless params[:category_id]
      category_ids = params[:category_id].is_a?(Array) ? params[:category_id] : params[:category_id].split(',')
      query_nested_array(posts, :lato_blog_categories, :id, category_ids)
    end

    def query_array(records, key, values)
      values.each do |value|
        records = records.where("#{key}": value)
      end
      records
    end

    def query_nested_array(records, key1, key2, values)
      values.each do |value|
        records = records.where("#{key1}": { "#{key2}": value })
      end
      records
    end

  end
end
