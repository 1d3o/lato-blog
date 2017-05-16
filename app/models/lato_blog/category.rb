module LatoBlog
  class Category < ApplicationRecord

    include ModelCategoryHelpers

    # Validations:

    validates :title, presence: true, uniqueness: true

    # Relations:

    has_many :categories, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category', dependent: :destroy
    belongs_to :parent_category, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category'

    # Callbacks:

    before_save do
      # TODO: Check presence of circular dependencies.
    end

  end
end
