# This migration comes from lato_blog (originally 20170516063317)
class CreateLatoBlogCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_categories do |t|
      t.string :title

      t.string :meta_permalink
      t.string :meta_language
      
      t.integer :lato_core_superuser_creator_id
      t.integer :lato_blog_category_parent_id
      t.integer :lato_blog_category_id

      t.timestamps
    end
  end
end
