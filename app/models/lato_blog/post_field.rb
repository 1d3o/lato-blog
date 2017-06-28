module LatoBlog
  class PostField < ApplicationRecord

    include PostField::EntityHelpers
    include PostField::SerializerHelpers

    # Properties:

    serialize :meta_datas, Hash

    # Relations:

    belongs_to :post, foreign_key: :lato_blog_post_id, class_name: 'LatoBlog::Post'

    # Validations:

    validates :key, presence: true
    validates :typology, presence: true

    # Scopes:

    scope :visibles, -> { where(meta_visible: true) }

  end
end

