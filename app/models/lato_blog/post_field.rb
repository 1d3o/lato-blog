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
                           class_name: 'LatoBlog::PostField',
                           dependent: :destroy
    belongs_to :post_field, foreign_key: :lato_blog_post_field_id,
                            class_name: 'LatoBlog::PostField',
                            optional: true

    # Validations:

    validates :key, presence: true

    # Scopes:

    scope :visibles, -> { where(meta_visible: true) }

    # Callbacks:

    after_update do
      update_child_visibility
    end

    private

    # This functions update all post fields child visibility with the current
    # post field visibility.
    def update_child_visibility
      post_fields.map { |pf| pf.update(meta_visible: meta_visible) }
    end

  end
end

