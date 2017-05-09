class CreateLatoBlogPostParents < ActiveRecord::Migration[5.1]
  def change
    create_table :lato_blog_post_parents do |t|

      t.timestamps
    end
  end
end
