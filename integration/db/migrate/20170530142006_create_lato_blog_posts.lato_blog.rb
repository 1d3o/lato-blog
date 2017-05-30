# This migration comes from lato_blog (originally 20170504222008)
class CreateLatoBlogPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_posts do |t|
      t.string :title
      t.string :subtitle
      t.text :excerpt
      t.text :content

      t.string :meta_permalink
      t.string :meta_status
      t.string :meta_language

      t.integer :lato_core_superuser_creator_id
      t.integer :lato_blog_post_parent_id
      
      t.timestamps
    end
  end
end
