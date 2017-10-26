module LatoBlog
  class Api::PostsController < Api::ApiController

    def index
      result = blog__get_posts(
        order: params[:order],
        language: params[:language],
        category_permalink: params[:category_permalink],
        category_permalink_AND: params[:category_permalink_AND],
        category_id: params[:category_id],
        category_id_AND: params[:category_id_AND],
        search: params[:search],
        page: params[:page],
        per_page: params[:per_page]
      )

      # render response
      core__send_request_success(result)
    end

    def show
      # check parameters
      core__send_request_fail('Uncorrect parameters') && return unless params[:id] || params[:permalink]

      post = blog__get_post(
        id: params[:id],
        permalink: params[:permalink]
      )

      # render respnse
      core__send_request_fail('Post not found') && return unless post
      core__send_request_success(post: post)
    end

  end
end
