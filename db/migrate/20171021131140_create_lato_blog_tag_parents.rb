class CreateLatoBlogTagParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_tag_parents do |t|
      # TODO
      t.timestamps
    end
  end
end
