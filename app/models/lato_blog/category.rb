module LatoBlog
  class Category < ApplicationRecord

    include ModelCategoryHelpers

    # Validations:

    validates :title, presence: true, uniqueness: true

    validates :meta_permalink, presence: true, uniqueness: true, length: { maximum: 250 }
    validates :meta_language, presence: true, length: { maximum: 250 }, inclusion: { in: ([nil] + BLOG_LANGUAGES_IDENTIFIER) }

    validates :lato_blog_category_parent_id, presence: true

    # Relations:

    belongs_to :category_parent, foreign_key: :lato_blog_category_parent_id, class_name: 'LatoBlog::CategoryParent'
    belongs_to :superuser_creator, foreign_key: :lato_core_superuser_creator_id, class_name: 'LatoCore::Superuser'

    # Callbacks:

    before_validation do
      check_meta_permalink
    end

    private

      # This function check if current permalink is valid. If it is not valid it
      # generate a new from the post title.
      def check_meta_permalink
        candidate = (self.meta_permalink ? self.meta_permalink : self.title.parameterize)
        accepted = nil
        counter = 0

        while accepted.nil?
          if LatoBlog::Category.find_by(meta_permalink: candidate)
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
