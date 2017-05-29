# This migration comes from lato_media (originally 20160224181218)
class CreateLatoMediaMedia < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_media_media do |t|
      t.string :title
      t.text :description

      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
  end
end
