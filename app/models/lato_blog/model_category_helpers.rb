module LatoBlog
  module ModelCategoryHelpers

    # This function return the pretty name of the language of the category.
    def get_pretty_language
      CONFIGS[:lato_blog][:languages].values.each do |language|
        return language[:title] if language[:identifier] === self.meta_language
      end
    end

    # This function returns a pretty presentation of the creation date for the post.
    def get_pretty_created_at
      return self.created_at.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns a pretty presentation of the update date for the post.
    def get_pretty_updated_at
      return self.updated_at.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns the name of the superuser creator of the post.
    def get_superuser_creator_name
      return self.superuser_creator ? self.superuser_creator.get_complete_name : 'Anonymous'
    end

    # This function return the title of the category father.
    def get_category_father_title
      return self.category_father.title if self.category_father
    end

    # This function the post translation for a specific language.
    def get_translation_for_language language_identifier
      return self.category_parent.categories.find_by(meta_language: language_identifier)
    end

    # This function return all category children of the current category.
    def get_all_category_children
      direct_children = self.category_children
      all_children = []

      direct_children.each do |direct_child|
        all_children.push(direct_child)
        all_children = all_children + direct_child.get_all_category_children
      end
      
      return all_children
    end

  end
end
