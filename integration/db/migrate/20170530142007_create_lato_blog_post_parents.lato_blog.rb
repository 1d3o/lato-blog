# This migration comes from lato_blog (originally 20170504223521)
class CreateLatoBlogPostParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_post_parents do |t|
      t.datetime :publication_datetime
      
      t.timestamps
    end
  end
end
