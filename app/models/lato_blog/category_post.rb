module LatoBlog
  class CategoryPost < ApplicationRecord

    # Validations:

    validates :lato_blog_category_id, presence: true
    validates :lato_blog_post_id, presence: true

    # Relations:

    belongs_to :category, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category'

    belongs_to :post, foreign_key: :lato_blog_post_id, class_name: 'LatoBlog::Post'

    # Callbacks:

    before_save do
      check_relation_language
    end

    private

    def check_relation_language
      if self.category.meta_language != self.post.meta_language
        errors.add('Category and Post', 'have not same language')
        throw :abort
      end
    end

  end
end
