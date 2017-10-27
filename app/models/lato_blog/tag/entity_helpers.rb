module LatoBlog
  module Tag::EntityHelpers

    # This function return the pretty name of the language of the tag.
    def get_pretty_language
      CONFIGS[:lato_blog][:languages].values.each do |language|
        return language[:title] if language[:identifier] === self.meta_language
      end
    end

    # This function returns a pretty presentation of the creation date for the post.
    def get_pretty_created_at
      self.created_at.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns a pretty presentation of the update date for the post.
    def get_pretty_updated_at
      self.updated_at.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns the name of the superuser creator of the post.
    def get_superuser_creator_name
      self.superuser_creator ? self.superuser_creator.get_complete_name : 'Anonymous'
    end

    # This function the post translation for a specific language.
    def get_translation_for_language language_identifier
      self.tag_parent.tags.find_by(meta_language: language_identifier)
    end

    # This function return the number of posts of the tag.
    def get_number_of_posts
      self.posts.length
    end

  end
end
