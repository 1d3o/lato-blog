module LatoBlog
  class Back::PostFieldsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    # Relay:
    # **************************************************************************

    def create_relay_field
      respond_to do |r|
        r.js
      end
    end

  end
end
