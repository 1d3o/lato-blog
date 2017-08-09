module LatoBlog
  module FieldsHelper

    # This function render the partial used to render post fields for a
    # specific post.
    def render_post_fields(post)
      post_fields = post.post_fields.visibles.roots.order('position ASC')
      render 'lato_blog/back/posts/shared/fields', post_fields: post_fields
    end

    # This function render a single post field.
    def render_post_field(post_field, key_parent = 'fields')
      # define key
      key = "#{key_parent}[#{post_field.id}]"
      # render correct field
      case post_field.typology
      when 'text'
        render_post_field_text(post_field, key)
      when 'datetime'
        render_post_field_datetime(post_field, key)
      when 'editor'
        render_post_field_editor(post_field, key)
      when 'geolocalization'
        render_post_field_geolocalization(post_field, key)
      when 'image'
        render_post_field_image(post_field, key)
      when 'youtube'
        render_post_field_youtube(post_field, key)
      when 'composed'
        render_post_field_composed(post_field, key)
      when 'relay'
        render_post_field_relay(post_field, key)
      end
    end

    # Specific field render functions:
    # **************************************************************************

    # Text.
    def render_post_field_text(post_field, key)
      render 'lato_blog/back/post_fields/fields/text', post_field: post_field, key: key
    end

    # Datetime.
    def render_post_field_datetime(post_field, key)
      render 'lato_blog/back/post_fields/fields/datetime', post_field: post_field, key: key
    end

    # Editor.
    def render_post_field_editor(post_field, key)
      render 'lato_blog/back/post_fields/fields/editor', post_field: post_field, key: key
    end

    # Geolocalization.
    def render_post_field_geolocalization(post_field, key)
      value_object = post_field.value ? eval(post_field.value) : nil
      render(
        'lato_blog/back/post_fields/fields/geolocalization',
        post_field: post_field,
        key: key,
        lat: value_object ? value_object[:lat] : nil,
        lng: value_object ? value_object[:lng] : nil,
        address: value_object ? value_object[:address] : nil
      )
    end

    # Image.
    def render_post_field_image(post_field, key)
      render 'lato_blog/back/post_fields/fields/image', post_field: post_field, key: key
    end

    # Youtube.
    def render_post_field_youtube(post_field, key)
      render 'lato_blog/back/post_fields/fields/youtube', post_field: post_field, key: key
    end

    # Composed.
    def render_post_field_composed(post_field, key)
      render 'lato_blog/back/post_fields/fields/composed', post_field: post_field, key: key
    end

    # Relay.
    def render_post_field_relay(post_field, key)
      render 'lato_blog/back/post_fields/fields/relay', post_field: post_field, key: key
    end

    # Single field helpers functions:
    # **************************************************************************

    def field_general_get_default_class
      'xs-12 sm-12 md-12 lg-12'
    end

    def field_relay_generate_components(post_field)
      components = []
      post_field.post_fields.visibles.order('position ASC').each do |child_post_field|
        components.push({
          id: "position#{child_post_field.id}",
          position: child_post_field.position,
          render: render_post_field(child_post_field, "fields[#{post_field.id}]")
        })
      end
      components
    end

  end
end