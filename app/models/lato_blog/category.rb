module LatoBlog
  class Category < ApplicationRecord

    include Category::EntityHelpers
    include Category::SerializerHelpers

    # Validations:

    validates :title, presence: true, uniqueness: true

    validates :meta_permalink, presence: true, uniqueness: true, length: { maximum: 250 }
    validates :meta_language, presence: true, length: { maximum: 250 }, inclusion: { in: ([nil] + BLOG_LANGUAGES_IDENTIFIER) }

    validates :lato_blog_category_parent_id, presence: true

    # Relations:

    belongs_to :category_parent, foreign_key: :lato_blog_category_parent_id, class_name: 'LatoBlog::CategoryParent'

    belongs_to :superuser_creator, foreign_key: :lato_core_superuser_creator_id, class_name: 'LatoCore::Superuser'

    has_many :category_children, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category', dependent: :nullify
    belongs_to :category_father, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::Category', optional: true

    has_many :post_relations, foreign_key: :lato_blog_category_id, class_name: 'LatoBlog::CategoryPost', dependent: :destroy
    has_many :posts, through: :post_relations

    # Scopes:

    scope :roots, -> { where(lato_blog_category_id: nil) }

    # Callbacks:

    before_validation :check_meta_permalink, on: :create

    before_save do
      self.meta_permalink = meta_permalink.parameterize
      meta_language.downcase!

      check_category_father_circular_dependency
      check_category_father_language
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
          counter += 1
          candidate = "#{candidate}-#{counter}"
        else
          accepted = candidate
        end
      end

      self.meta_permalink = accepted
    end

    # This function check the category parent of the category do not create a circular dependency.
    def check_category_father_circular_dependency
      return unless self.lato_blog_category_id

      all_children = self.get_all_category_children
      same_children = all_children.select { |child| child.id === self.lato_blog_category_id }

      if same_children.length > 0
        errors.add('Category father', 'can not be a children of the category')
        throw :abort
      end
    end

    # This function check the chategory parent has the same language of the child.
    def check_category_father_language
      return unless self.lato_blog_category_id
      if self.category_father.meta_language != self.meta_language
        errors.add('Category father', 'must have the same language of the child')
        throw :abort
      end
    end

  end
end
