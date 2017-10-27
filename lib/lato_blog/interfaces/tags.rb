module LatoBlog
  
  # This module contains a list of functions used to manage tags for the blog.
  module Interface::Tags

    # This function cleans all old tag parents without any child.
    def blog__clean_tag_parents
      tag_parents = LatoBlog::TagParent.all
      tag_parents.map { |tp| tp.destroy if tp.tags.empty? }
    end

  end
end
  