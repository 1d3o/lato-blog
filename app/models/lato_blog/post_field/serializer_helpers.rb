module LatoBlog
  module PostField::SerializerHelpers

    def serialize_base
      serialized = {}

      # set basic info
      serialized[:key] = key
      serialized[:typology] = typology
      serialized[:value] = serialize_value

      # return serialized post
      serialized
    end

    private

    # This function returns the correct serialized value of the field.
    def serialize_value
      case typology
      when 'TODO'
        nil
      else
        value
      end
    end

  end
end
