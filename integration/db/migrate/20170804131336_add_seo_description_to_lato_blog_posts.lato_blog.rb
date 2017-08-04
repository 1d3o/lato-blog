# This migration comes from lato_blog (originally 20170804131140)
class AddSeoDescriptionToLatoBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :lato_blog_posts, :seo_description, :text
  end
end
