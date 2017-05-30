module LatoBlog
  module FieldsHelper

    # This function render a single custom post field.
    def render_post_field(post, key)
      post_field = post.post_fields.find_by(key: key)
      return unless post_field

      case post_field.typology
      when 'text'
        render 'lato_blog/back/posts/shared/fields/text', field: post_field
      else
        return
      end
    end

  end
end
