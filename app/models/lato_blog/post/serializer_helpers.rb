module LatoBlog
  module Post::SerializerHelpers

    def serialize
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:subtitle] = subtitle
      serialized[:excerpt] = excerpt
      serialized[:content] = content
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink
      serialized[:meta_status] = meta_status

      # return serialized post
      serialized
    end

  end
end
