module LatoBlog
  module Tag::SerializerHelpers

    # This function serializes a complete version of the tag.
    def serialize
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink

      # add tag parent informations
      serialized[:other_informations] = serialize_other_informations

      # return serialized post
      serialized
    end

    # This function serializes a basic version of the tag.
    def serialize_base
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink

      # return serialized tag
      serialized
    end

    private

    def serialize_other_informations
      serialized = {}

      # set translations links
      serialized[:translations] = {}
      tag_parent.tags.each do |tag|
        next if tag.id == id
        serialized[:translations][tag.meta_language] = tag.serialize_base
      end

      # return serialzed informations
      serialized
    end

  end
end
