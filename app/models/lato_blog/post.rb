module LatoBlog
  class Post < ApplicationRecord

    include PostHelpers

    # Validations:

    validates :title, presence: true, length: { maximum: 250 }
    validates :meta_permalink, presence: true, uniqueness: true, length: { maximum: 250 }
    validates :meta_status, presence: true, length: { maximum: 250 }, inclusion: { in: BLOG_POSTS_STATUS.values }
    validates :meta_language, presence: true, length: { maximum: 250 }, inclusion: { in: ([nil] + BLOG_LANGUAGES_IDENTIFIER) }
    validates :lato_core_superuser_creator_id, presence: true

    # Callbacks:

    before_save do
      meta_permalink.downcase!
      meta_status.downcase!
      meta_language.downcase!
    end

  end
end
