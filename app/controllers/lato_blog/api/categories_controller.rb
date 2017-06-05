module LatoBlog
  class Api::CategoriesController < Api::ApiController

    def index
      categories = LatoBlog::Category.all
      total = categories.length

      # order categories
      order = (params[:order] && params[:order] == 'ASC') ? 'ASC' : 'DESC'
      categories = categories.order("title #{order}")

      # filter language
      categories = categories.where(meta_language: params[:language]) if params[:language]
      # filter search
      categories = categories.where('title like ?', "%#{params[:search]}%") if params[:search]

      # manage pagination
      page = params[:page] ? params[:page].to_i : 1
      per_page = params[:per_page] ? params[:per_page].to_i : 20
      categories = core__paginate_array(categories, per_page, page)

      # render response
      core__send_request_success(
        categories: categories.map(&:serialize),
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
        category = LatoBlog::Category.find_by(id: params[:id].to_i)
      else
        category = LatoBlog::Category.find_by(meta_permalink: params[:permalink])
      end

      # render respnse
      core__send_request_fail('Category not found') && return unless category
      core__send_request_success(category: category.serialize)
    end

  end
end