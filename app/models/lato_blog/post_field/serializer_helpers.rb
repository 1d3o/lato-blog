module LatoBlog
  module PostField::SerializerHelpers

    # This function serializes a basic version of the post field.
    def serialize_base
      serialized = {}

      # set basic info
      serialized[:key] = key
      serialized[:typology] = typology
      serialized[:value] = serialize_field_value

      # return serialized post
      serialized
    end

    private

    # Serializer field value:
    # **************************************************************************

    # This function serialize the field value of the post field.
    def serialize_field_value
      case typology
      when 'text'
        serialize_field_value_text
      when 'editor'
        serialize_field_value_editor
      when 'geolocalization'
        serialize_field_value_geolocalization
      when 'image'
        serialize_field_value_image
      when 'composed'
        serialize_field_value_composed
      when 'relay'
        serialize_field_value_relay
      end
    end

    # Serializer specific field value:
    # **************************************************************************

    # Text.
    def serialize_field_value_text
      value
    end

    # Editor.
    def serialize_field_value_editor
      value
    end

    # Geolocalization.
    def serialize_field_value_geolocalization
      return unless value
      value_object = eval(value)
      serialized = {}

      # add basic info
      serialized[:latitude] = value_object[:lat]
      serialized[:longitude] = value_object[:lng]
      serialized[:address] = value_object[:address]

      # return serialized data
      serialized
    end

    # Image.
    def serialize_field_value_image
      media = LatoMedia::Media.find_by(id: value)
      return unless media

      # add basic info
      serialized = {}
      serialized[:id] = media.id
      serialized[:title] = media.title
      serialized[:url] = media.attachment.url

      # add image info
      serialized[:thumb_url] = (media.image? ? media.attachment.url(:thumb) : nil)
      serialized[:medium_url] = (media.image? ? media.attachment.url(:medium) : nil)
      serialized[:large_url] = (media.image? ? media.attachment.url(:large) : nil)

      # return serialized media
      serialized
    end

    # Composed.
    def serialize_field_value_composed
      serialized = {}
      post_fields.visibles.order('position ASC').each do |post_field|
        serialized[post_field.key] = post_field.serialize_base
      end
      serialized
    end

    # Relay.
    def serialize_field_value_relay
      serialized = []
      post_fields.visibles.order('position ASC').each do |post_field|
        serialized.push(post_field.serialize_base)
      end
      serialized
    end

  end
end
