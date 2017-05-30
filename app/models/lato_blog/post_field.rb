module LatoBlog
  class PostField < ApplicationRecord

    # Relations:

    belongs_to :post, foreign_key: :lato_blog_post_id, class_name: 'LatoBlog::Post'

    # Validations:

    validates :key, presence: true
    validates :typology, presence: true

  end
end

