module LatoBlog
  class CategoryParent < ApplicationRecord

    # Relations:

    has_many :categories, foreign_key: :lato_blog_category_parent_id, class_name: 'LatoBlog::Category', dependent: :destroy

  end
end