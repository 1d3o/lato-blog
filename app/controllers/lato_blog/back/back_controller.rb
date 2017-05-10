module LatoBlog
  class Back::BackController < ApplicationController

    layout 'lato_core/admin'

    # check user is logged
    before_action :core__manage_superuser_session
    # set default language if not exist
    before_action :set_default_current_language

    # This function switch the default language used by the system and redirect to the same user page.
    def switch_current_language
      languages = blog__get_languages_identifier
      if languages.include? params[:language]
        cookies[:lato_blog__current_language] = params[:language]
      elsif languages && languages.length > 0
        cookies[:lato_blog__current_language] = languages.first 
      end
      
      redirect_to lato_blog.root_path
    end

    private

      def set_default_current_language
        if !cookies[:lato_blog__current_language]
          languages = blog__get_languages_identifier
          cookies[:lato_blog__current_language] = (languages && languages.length > 0) ? languages.first : nil
        end
      end
    
  end
end
