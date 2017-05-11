module LatoBlog
  module ApplicationHelper

    def get_current_language_title
      return unless cookies[:lato_blog__current_language]
      CONFIGS[:lato_blog][:languages].values.each do |language|
        return language[:title] if language[:identifier] === cookies[:lato_blog__current_language]
      end
    end
    
  end
end
