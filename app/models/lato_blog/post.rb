module LatoBlog
  class Post < ApplicationRecord

    include PostHelpers

    # Validations:

    validates :title, presence: true, length: { maximum: 250 }

    validates :meta_permalink, presence: true, uniqueness: true, length: { maximum: 250 }
    validates :meta_status, presence: true, length: { maximum: 250 }, inclusion: { in: BLOG_POSTS_STATUS.values }
    validates :meta_language, presence: true, length: { maximum: 250 }, inclusion: { in: ([nil] + BLOG_LANGUAGES_IDENTIFIER) }

    validates :lato_core_superuser_creator_id, presence: true

    # Relations:

    belongs_to :post_parent, foreign_key: :lato_blog_post_parent_id, class_name: 'LatoBlog::PostParent'

    # Scopes:

    scope :published, -> { where(meta_status: BLOG_POSTS_STATUS[:published]) }
    scope :drafted, -> { where(meta_status: BLOG_POSTS_STATUS[:drafted]) }
    scope :deleted, -> { where(meta_status: BLOG_POSTS_STATUS[:deleted]) }

    # Callbacks:

    before_validation do
      check_meta_permalink
    end

    before_save do
      meta_permalink.downcase!
      meta_status.downcase!
      meta_language.downcase!
    end

    private 

      # This function check if current permalink is valid. If it is not valid it
      # generate a new from the post title.
      def check_meta_permalink
        candidate = (self.meta_permalink ? self.meta_permalink : self.title.parameterize)
        accepted = nil
        counter = 0

        while accepted.nil?
          if LatoBlog::Post.find_by(meta_permalink: candidate)
            counter = counter + 1
            candidate = "#{candidate}-#{counter}"
          else
            accepted = candidate
          end
        end

        self.meta_permalink = accepted
      end

  end
end
