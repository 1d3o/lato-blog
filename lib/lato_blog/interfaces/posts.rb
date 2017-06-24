module LatoBlog

  # This module contains a list of functions used to manage posts for the blog.
  module Interface::Posts

    # This function cleans all old post parents without any child.
    def blog__clean_post_parents
      post_parents = LatoBlog::PostParent.all
      post_parents.map { |pp| pp.destroy if pp.posts.empty? }
    end

  end
end
