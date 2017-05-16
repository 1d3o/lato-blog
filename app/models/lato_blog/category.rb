module LatoBlog
  class Category < ApplicationRecord

    include ModelCategoryHelpers

    # Serializations:

    serialize :names, Hash

    # Validations:

    validates :names, presence: true

    # Relations:

    has_many :categories, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category'
    belongs_to :parent_category, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category'

    # Callbacks:

    before_save do
      # TODO: Check presence of circular dependencies
    end

  end
end
