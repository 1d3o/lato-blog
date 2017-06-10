module LatoBlog
  module FieldsHelper

    # This function render a single custom post field.
    def render_post_field(post_field)
      field = CONFIGS[:lato_blog][:post_fields][post_field.key]
      return unless field

      case post_field.typology
      when 'text'
        render 'lato_blog/back/posts/shared/fields/text', post_field: post_field, field: field
      when 'media'
        render 'lato_blog/back/posts/shared/fields/media', post_field: post_field, field: field
      when 'geolocalization'
        render_geolocalization(post_field, field)
      else
        return
      end
    end

    private

    # This function render the geolocalization input.
    def render_geolocalization(post_field, field)
      value_object = post_field.value ? eval(post_field.value) : nil
      latitude = value_object ? value_object[:lat] : nil
      longitude = value_object ? value_object[:lng] : nil
      address = value_object ? value_object[:address] : nil
      render 'lato_blog/back/posts/shared/fields/geolocalization', post_field: post_field, field: field,
             latitude: latitude, longitude: longitude, address: address
    end

  end
end
