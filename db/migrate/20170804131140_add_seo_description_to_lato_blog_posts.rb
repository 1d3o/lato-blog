class AddSeoDescriptionToLatoBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :lato_blog_posts, :seo_description, :text
  end
end
