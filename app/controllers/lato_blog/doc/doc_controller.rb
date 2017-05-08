module LatoBlog
  class Doc::DocController < ApplicationController

    layout 'lato_core/admin'

    before_action :core__manage_superuser_session

  end
end
