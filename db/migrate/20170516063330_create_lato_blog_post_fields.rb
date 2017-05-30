class CreateLatoBlogPostFields < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_post_fields do |t|
      t.integer :lato_blog_post_id
      t.string :key
      t.string :typology
      t.string :label
      t.text :value

      t.timestamps
    end
  end
end
