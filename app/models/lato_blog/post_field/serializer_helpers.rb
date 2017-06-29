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
      when 'composed'
        serialize_field_value_composed
      end
    end

    # Serializer specific field value:
    # **************************************************************************

    # Text.
    def serialize_field_value_text
      value
    end

    # Composed.
    def serialize_field_value_composed
      serialized_value = {}
      post_fields.visibles.each do |post_field|
        serialized_value[post_field.key] = post_field.serialize_base
      end
      serialized_value
    end

  end
end
