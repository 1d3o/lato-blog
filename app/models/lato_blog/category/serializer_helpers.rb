module LatoBlog
  module Category::SerializerHelpers

    def serialize_base
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink

      # return serialized post
      serialized
    end

  end
end
