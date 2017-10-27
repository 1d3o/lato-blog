# This migration comes from lato_blog (originally 20171022131140)
class CreateLatoBlogTagPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_tag_posts do |t|
      t.integer :lato_blog_tag_id
      t.integer :lato_blog_post_id

      t.timestamps
    end
  end
end
