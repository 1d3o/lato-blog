class CreateLatoBlogPostFields < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_post_fields do |t|
      t.integer :lato_blog_post_id
      t.string :typology
      t.text :value

      t.timestamps
    end
  end
end
