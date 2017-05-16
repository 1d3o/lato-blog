module LatoBlog
  module Post::EntityHelpers

    # This function returns a pretty presentation of the pubblication date for the post.
    def get_pretty_publication_datetime
      return self.post_parent.publication_datetime.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns a pretty presentation of the creation date for the post.
    def get_pretty_created_at
      return self.created_at.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns a pretty presentation of the update date for the post.
    def get_pretty_updated_at
      return self.updated_at.strftime('%d/%m/%Y - %H:%M')
    end

    # This function returns a pretty presentation of the post status.
    def get_pretty_status
      return LANGUAGES[:lato_blog][:posts_status][self.meta_status]
    end

    # This function returns a pretty presentation of the post language.
    def get_pretty_language
      CONFIGS[:lato_blog][:languages].values.each do |language|
        return language[:title] if language[:identifier] === self.meta_language
      end
    end

    # This function returns the name of the superuser creator of the post.
    def get_superuser_creator_name
      return self.superuser_creator ? self.superuser_creator.get_complete_name : 'Anonymous'
    end

    # This function the post translation for a specific language.
    def get_translation_for_language language_identifier
      return self.post_parent.posts.find_by(meta_language: language_identifier)
    end  

  end  
end
