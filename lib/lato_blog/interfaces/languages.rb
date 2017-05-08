module LatoBlog

  # This module contains a list of functions used to manage languages for the blog.
  module Interface::Languages

    # This function return an array with possible languages for posts.
    def blog__get_languages_identifier
      languages = CONFIGS[:lato_blog][:languages]
      return [] unless languages

      return languages.values.map{|lang| lang[:identifier]}
    end

  end
end