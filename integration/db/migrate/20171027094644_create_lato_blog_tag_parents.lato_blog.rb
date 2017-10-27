# This migration comes from lato_blog (originally 20171021131140)
class CreateLatoBlogTagParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_tag_parents do |t|
      # TODO
      t.timestamps
    end
  end
end
