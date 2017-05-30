module LatoBlog
  module FieldsHelper

    # This function render a single custom post field.
    def render_post_field(post, field, key)
      post_field = post.post_fields.find_by(key: key)
      return unless post_field

      case post_field.typology
      when 'text'
        render 'lato_blog/back/posts/shared/fields/text', post_field: post_field, field: field
      when 'media'
        render 'lato_blog/back/posts/shared/fields/media', post_field: post_field, field: field
      else
        return
      end
    end

  end
end
