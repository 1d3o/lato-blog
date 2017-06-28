module LatoBlog
  class PostField < ApplicationRecord

    include PostField::EntityHelpers
    include PostField::SerializerHelpers

    # Properties:

    serialize :meta_datas, Hash

    # Relations:

    belongs_to :post, foreign_key: :lato_blog_post_id,
                      class_name: 'LatoBlog::Post'

    has_many :post_fields, foreign_key: :lato_blog_post_field_id,
                           class_name: 'LatoBlog::PostField'

    belongs_to :post_field, foreign_key: :lato_blog_post_field_id,
                            class_name: 'LatoBlog::PostField', optional: true

    # Validations:

    validates :key, presence: true

    # Scopes:

    scope :visibles, -> { where(meta_visible: true) }

  end
end

