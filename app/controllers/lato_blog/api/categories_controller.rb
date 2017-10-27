module LatoBlog
  class Api::CategoriesController < Api::ApiController

    def index
      result = blog__get_categories(
        order: params[:order],
        language: params[:language],
        search: params[:search],
        page: params[:page].to_i,
        per_page: params[:per_page].to_i
      )

      # render response
      core__send_request_success(result)
    end

    def show
      # check parameters
      core__send_request_fail('Uncorrect parameters') && return unless params[:id] || params[:permalink]

      category = blog__get_category(
        id: params[:id],
        permalink: params[:permalink]
      )

      # render respnse
      core__send_request_fail('Category not found') && return unless category
      core__send_request_success(category: category)
    end

  end
end
