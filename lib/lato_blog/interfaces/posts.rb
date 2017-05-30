module LatoBlog

  # This module contains a list of functions used to manage posts for the blog.
  module Interface::Posts

    # This function creates posts fields on database for every post from the config file.
    def blog__create_posts_fields
      posts = LatoBlog::Post.all
      posts.each do |post|
        blog__create_post_fields(post)
      end
    end

    # This function creates post fields on database for a specific post from the config file.
    def blog__create_post_fields(post)
      fields = CONFIGS[:lato_blog][:post_fields]
      fields.each do |field|
        post_field = post.post_fields.find_by(key: field.first)
        next if post_field

        LatoBlog::PostField.create(key: field.first, typology: field.last[:type],
                                   label: field.last[:label], lato_blog_post_id: post.id)
      end
    end

  end
end
