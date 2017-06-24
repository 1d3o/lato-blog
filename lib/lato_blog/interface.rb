module LatoBlog
  module Interface

    require 'lato_blog/interfaces/languages'
    include LatoBlog::Interface::Languages

    require 'lato_blog/interfaces/posts'
    include LatoBlog::Interface::Posts

    require 'lato_blog/interfaces/categories'
    include LatoBlog::Interface::Categories

  end
end
