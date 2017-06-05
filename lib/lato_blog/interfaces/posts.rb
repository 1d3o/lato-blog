module LatoBlog

  # This module contains a list of functions used to manage posts for the blog.
  module Interface::Posts

    # This function creates posts fields on database for every post from the config file.
    def blog__manage_posts_fields
      posts = LatoBlog::Post.all
      posts.each do |post|
        blog__manage_post_fields(post)
      end
    end

    # This function creates post fields on database for a specific post from the config file.
    def blog__manage_post_fields(post)
      fields = CONFIGS[:lato_blog][:post_fields]
      fields.each do |field|
        post_field = post.post_fields.find_by(key: field.first)
        visible = !(field.last[:categories] && (field.last[:categories] & post.categories.pluck(:meta_permalink)).empty?)

        if visible && !post_field # post field not exist and should be visible
          LatoBlog::PostField.create(key: field.first, typology: field.last[:type],
                                     lato_blog_post_id: post.id, meta_visible: true)
        elsif visible && post_field && !post_field.meta_visible # post field exist, is not visible and should be visible
          post_field.update(meta_visible: true)
        elsif !visible && post_field && post_field.meta_visible # post field exist, is visible and should not be visible
          post_field.update(meta_visible: false)
        end
      end
    end

  end
end
