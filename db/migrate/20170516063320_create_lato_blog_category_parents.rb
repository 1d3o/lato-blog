class CreateLatoBlogCategoryParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_category_parents do |t|
      t.boolean :meta_default

      t.timestamps
    end
  end
end
