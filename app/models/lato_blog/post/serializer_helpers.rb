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

      # add fields informations
      serialized[:fields] = serialize_fields

      # add categories informations
      serialized[:categories] = serialize_categories

      # add post parent informations
      serialized[:other_informations] = serialize_post_parent

      # return serialized post
      serialized
    end

    private

    def serialize_fields
      serialized = {}
      post_fields.visibles.each do |post_field|
        serialized[post_field.key] = post_field.serialize
      end
      serialized
    end

    def serialize_categories
      {}
    end

    def serialize_post_parent
      {}
    end

  end
end
