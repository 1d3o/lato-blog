# This migration comes from lato_blog (originally 20171020131140)
class CreateLatoBlogTags < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_tags do |t|
      t.string :title

      t.string :meta_permalink
      t.string :meta_language

      t.integer :lato_core_superuser_creator_id
      t.integer :lato_blog_tag_parent_id

      t.timestamps
    end
  end
end
