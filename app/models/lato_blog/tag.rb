module LatoBlog
  class Tag < ApplicationRecord

    include Tag::EntityHelpers
    include Tag::SerializerHelpers

    # Validations:

    validates :title, presence: true, length: { maximum: 250 }

    validates :meta_permalink, presence: true, uniqueness: true,
                               length: { maximum: 250 }
    validates :meta_language, presence: true, length: { maximum: 250 },
                              inclusion: { in: ([nil] + BLOG_LANGUAGES_IDENTIFIER) }

    # Relations:

    belongs_to :tag_parent, foreign_key: :lato_blog_tag_parent_id,
                            class_name: 'LatoBlog::TagParent'

    belongs_to :superuser_creator, foreign_key: :lato_core_superuser_creator_id,
                                   class_name: 'LatoCore::Superuser'

    has_many :post_relations, foreign_key: :lato_blog_tag_id,
                              class_name: 'LatoBlog::TagPost',
                              dependent: :destroy
    has_many :posts, through: :post_relations

    # Callbacks:

    before_validation :check_meta_permalink, on: :create

    before_save do
      self.meta_permalink = meta_permalink.parameterize
      meta_language.downcase!

      check_lato_blog_tag_parent
    end

    after_destroy do
      blog__clean_tag_parents
    end

    private

    # This function check if current permalink is valid. If it is not valid it
    # generate a new from the post title.
    def check_meta_permalink
      candidate = (self.meta_permalink ? self.meta_permalink : self.title.parameterize)
      accepted = nil
      counter = 0

      while accepted.nil?
        if LatoBlog::Tag.find_by(meta_permalink: candidate)
          counter += 1
          candidate = "#{candidate}-#{counter}"
        else
          accepted = candidate
        end
      end

      self.meta_permalink = accepted
    end

    # This function check that the category parent exist and has not others tags for the same language.
    def check_lato_blog_tag_parent
      tag_parent = LatoBlog::TagParent.find_by(id: lato_blog_tag_parent_id)
      if !tag_parent
        errors.add('Tag parent', 'not exist for the tag')
        throw :abort
        return
      end

      same_language_tag = tag_parent.tags.find_by(meta_language: meta_language)
      if same_language_tag && same_language_tag.id != id
        errors.add('Tag parent', 'has another tag for the same language')
        throw :abort
        return
      end
    end

  end
end
