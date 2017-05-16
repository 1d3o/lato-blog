class CreateLatoBlogCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_categories do |t|
      t.text :names

      t.integer :lato_blog_category_id

      t.timestamps
    end
  end
end
