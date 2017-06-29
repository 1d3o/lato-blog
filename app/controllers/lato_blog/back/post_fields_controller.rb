module LatoBlog
  class Back::PostFieldsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # Relay:
    # **************************************************************************

    # This function create a new field for the post.
    def create_relay_field
      # find post field
      @post_field = LatoBlog::PostField.find_by(id: params[:post_field_id])
      unless @post_field
        @error = true
        respond_to { |r| r.js }
      end
      # find subfield info
      child_field_info = post_field[:meta_datas][:fields].map { |f| f if f.first == params[:key] }
      unless child_field_info
        @error = true
        respond_to { |r| r.js }
      end
      # create subfield for the post field
      blog__create_db_post_field(@post_field.post, child_field_info.first, child_field_info.last, @post_field)
      # send response to client
      @error = false
      respond_to { |r| r.js }
    end

    # This function destroy a post for the field.
    def destroy_relay_field
      # find post field
      @post_field = LatoBlog::PostField.find_by(id: params[:post_field_id])
      unless @post_field
        @error = true
        respond_to { |r| r.js }
      end
      # find post field child and destroy it
      child_field = @post_field.post_fields.find_by(key: params[:key])
      unless child_field || child_field.destroy
        @error = true
        respond_to { |r| r.js }
      end
      # send response to client
      @error = false
      respond_to { |r| r.js }
    end

  end
end
