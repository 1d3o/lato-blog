module LatoBlog
  module Category::SerializerHelpers

    # This function serializes a complete version of the category.
    def serialize
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink

      # add category father informations
      serialized[:category_father] = category_father ? category_father.serialize_base : nil

      # add category children informations
      serialized[:category_children] = serialize_category_children

      # add category parent informations
      serialized[:other_informations] = serialize_other_informations

      # return serialized post
      serialized
    end

    # This function serializes a basic version of the category.
    def serialize_base
      serialized = {}

      # set basic info
      serialized[:id] = id
      serialized[:title] = title
      serialized[:meta_language] = meta_language
      serialized[:meta_permalink] = meta_permalink

      # return serialized category
      serialized
    end

    private

    def serialize_category_children
      serialized = {}
      category_children.each do |category|
        serialized[category.id] = category.serialize_base
      end
      serialized
    end

    def serialize_other_informations
      serialized = {}

      # set translations links
      serialized[:translations] = {}
      category_parent.categories.each do |category|
        next if category.id == id
        serialized[:translations][category.meta_language] = category.serialize_base
      end

      # return serialzed informations
      serialized
    end

  end
end
