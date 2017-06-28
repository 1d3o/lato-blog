module LatoBlog
  module Post::SerializerHelpers

    # This function serializes a complete version of the post.
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
      serialized[:other_informations] = serialize_other_informations

      # return serialized post
      serialized
    end

    # This function serializes a basic version of the post.
    def serialize_base
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink
      serialized[:meta_status] = meta_status

      # return serialized post
      serialized
    end
    
    private

    # This function serializes the list of fields for the post.
    def serialize_fields
      serialized = {}
      post_fields.visibles.where(lato_blog_post_field_id: nil).each do |post_field|
        serialized[post_field.key] = post_field.serialize_base
      end
      serialized
    end

    # This function serializes the list of cateogories for the post.
    def serialize_categories
      serialized = {}
      categories.each do |category|
        serialized[category.id] = category.serialize_base
      end
      serialized
    end

    # This function serializes other informations for the post.
    def serialize_other_informations
      serialized = {}

      # set pubblication datetime
      serialized[:publication_datetime] = post_parent.publication_datetime

      # set translations links
      serialized[:translations] = {}
      post_parent.posts.published.each do |post|
        next if post.id == id
        serialized[:translations][post.meta_language] = post.serialize_base
      end

      # return serialzed informations
      serialized
    end

  end
end
