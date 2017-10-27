module LatoBlog
  class TagParent < ApplicationRecord

    # Relations:

    has_many :tags, foreign_key: :lato_blog_tag_parent_id, class_name: 'LatoBlog::Tag', dependent: :destroy

  end
end
