module LatoBlog
  module ApplicationHelper

    def get_current_language_title
      return unless cookies[:lato_blog__current_language]
      CONFIGS[:lato_blog][:languages].values.each do |language|
        return language[:title] if language[:identifier] === cookies[:lato_blog__current_language]
      end
    end

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
