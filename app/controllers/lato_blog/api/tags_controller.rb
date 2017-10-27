module LatoBlog
  class Api::TagsController < Api::ApiController

    def index
      result = blog__get_tags(
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

      tag = blog__get_tag(
        id: params[:id],
        permalink: params[:permalink]
      )

      # render respnse
      core__send_request_fail('Tag not found') && return unless tag
      core__send_request_success(tag: tag)
    end

  end
end
