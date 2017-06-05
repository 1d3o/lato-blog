module LatoBlog
  class Api::PostsController < Api::ApiController

    def index
      posts = LatoBlog::Post.published.joins(:categories).joins(:post_parent)
      posts = posts.where('lato_blog_post_parents.publication_datetime <= ?', DateTime.now)

      # order posts
      order_value = (params[:order] && params[:order] == 'ASC') ? 'ASC' : 'DESC'
      posts = posts.order("lato_blog_post_parents.publication_datetime #{order_value}")

      # filter language
      posts = posts.where(meta_language: params[:language]) if params[:language]
      # filter category permalink
      posts = posts.where(lato_blog_categories: {meta_permalink: params[:category_permalink]}) if params[:category_permalink]
      # filter category id
      posts = posts.where(lato_blog_categories: {id: params[:category_id]}) if params[:category_id]
      # filter search
      posts = posts.where('lato_blog_posts.title like ?', "%#{params[:search]}%") if params[:search]

      # manage pagination
      page = params[:page] ? params[:page].to_i : 1
      per_page = params[:per_page] ? params[:per_page].to_i : 20
      posts = core__paginate_array(posts, per_page, page)

      core__send_request_success(posts: posts.map(&:serialize))
    end

  end
end