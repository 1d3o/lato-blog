module LatoBlog
  class Back::BackController < ApplicationController

    # Specific helpers import to fix not found functions bug
    helper LatoBlog::ApplicationHelper
    helper LatoBlog::FieldsHelper

    layout 'lato_core/admin'

    # check user is logged
    before_action :core__manage_superuser_session
    # set default language if not exist
    before_action :set_default_current_language

    # This function switch the default language used by the system and redirect to the same user page.
    def switch_current_language
      set_current_language params[:language]

      respond_to do |format|
        format.js
      end
    end

    private

    # Language helpers:

    # This function set a default language on cookie if no languages are set.
    def set_default_current_language
      if !cookies[:lato_blog__current_language]
        cookies[:lato_blog__current_language] = BLOG_LANGUAGES_IDENTIFIER.first
      end
    end

    # This function set the language received as params as default language if it is possible.
    def set_current_language language
      if BLOG_LANGUAGES_IDENTIFIER.include? language
        cookies[:lato_blog__current_language] = language
      else
        set_default_current_language
      end
    end

  end
end
