# This migration comes from lato_blog (originally 20170516063320)
class CreateLatoBlogCategoryParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_category_parents do |t|

      t.timestamps
    end
  end
end
