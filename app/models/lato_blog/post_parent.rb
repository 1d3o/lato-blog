module LatoBlog
  class PostParent < ApplicationRecord

    include ModelPostParentHelpers

    # Validations:

    validates :publication_datetime, presence: true

    # Relations:

    has_many :posts, foreign_key: :lato_blog_post_parent_id, class_name: 'LatoBlog::Post', dependent: :destroy

    # Calbacks:

    before_validation do
      self.publication_datetime = DateTime.now if !self.publication_datetime
    end

  end
end
