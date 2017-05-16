class CreateLatoBlogCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_categories do |t|
      t.string :title

      t.integer :lato_blog_category_id

      t.timestamps
    end
  end
end
