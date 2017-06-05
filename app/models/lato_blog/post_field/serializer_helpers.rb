module LatoBlog
  module PostField::SerializerHelpers

    def serialize
      serialized = {}

      # set basic info
      serialized[:key] = key
      serialized[:typology] = typology

      # return serialized post
      serialized
    end

  end
end
