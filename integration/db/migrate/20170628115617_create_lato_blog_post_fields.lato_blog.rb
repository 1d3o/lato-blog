# This migration comes from lato_blog (originally 20170516063330)
class CreateLatoBlogPostFields < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_post_fields do |t|
      t.integer :lato_blog_post_id
      t.string :key
      t.string :typology
      t.text :value

      t.text :meta_datas
      t.boolean :meta_visible

      t.integer :lato_blog_post_field_id

      t.timestamps
    end
  end
end
