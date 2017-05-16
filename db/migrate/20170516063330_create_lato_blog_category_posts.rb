class CreateLatoBlogCategoryParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_category_posts do |t|
      t.integer :lato_blog_category_id
      t.integer :lato_blog_post_id
      
      t.timestamps
    end
  end
end
