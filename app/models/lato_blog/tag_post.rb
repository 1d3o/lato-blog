module LatoBlog
  class TagPost < ApplicationRecord

    # Validations:

    validates :lato_blog_tag_id, presence: true
    validates :lato_blog_post_id, presence: true

    # Relations:

    belongs_to :tag, foreign_key: :lato_blog_tag_id, class_name: 'LatoBlog::Tag'

    belongs_to :post, foreign_key: :lato_blog_post_id, class_name: 'LatoBlog::Post'

    # Callbacks:

    before_save do
      check_relation_language
    end

    private

    def check_relation_language
      if self.tag.meta_language != self.post.meta_language
        errors.add('Tag and Post', 'have not same language')
        throw :abort
      end
    end

  end
end
