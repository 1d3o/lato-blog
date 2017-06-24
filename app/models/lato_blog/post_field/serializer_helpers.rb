module LatoBlog
  module PostField::SerializerHelpers

    def serialize_base
      serialized = {}

      # set basic info
      serialized[:key] = key
      serialized[:typology] = typology
      serialized[:value] = nil

      # return serialized post
      serialized
    end

  end
end
