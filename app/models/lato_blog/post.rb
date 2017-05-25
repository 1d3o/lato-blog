module LatoBlog
  class Post < ApplicationRecord

    include Post::EntityHelpers

    # Validations:

    validates :title, presence: true, length: { maximum: 250 }

    validates :meta_permalink, presence: true, uniqueness: true, length: { maximum: 250 }
    validates :meta_status, presence: true, length: { maximum: 250 }, inclusion: { in: BLOG_POSTS_STATUS.values }
    validates :meta_language, presence: true, length: { maximum: 250 }, inclusion: { in: ([nil] + BLOG_LANGUAGES_IDENTIFIER) }

    validates :lato_core_superuser_creator_id, presence: true
    validates :lato_blog_post_parent_id, presence: true

    # Relations:

    belongs_to :post_parent, foreign_key: :lato_blog_post_parent_id, class_name: 'LatoBlog::PostParent'
    
    belongs_to :superuser_creator, foreign_key: :lato_core_superuser_creator_id, class_name: 'LatoCore::Superuser'

    has_many :category_relations, foreign_key: :lato_blog_post_id, class_name: 'LatoBlog::CategoryPost', dependent: :destroy
    has_many :categories, through: :category_relations

    # Scopes:

    scope :published, -> { where(meta_status: BLOG_POSTS_STATUS[:published]) }
    scope :drafted, -> { where(meta_status: BLOG_POSTS_STATUS[:drafted]) }
    scope :deleted, -> { where(meta_status: BLOG_POSTS_STATUS[:deleted]) }

    # Callbacks:

    before_validation do
      check_meta_permalink
    end

    before_save do
      self.meta_permalink.downcase!
      self.meta_status.downcase!
      self.meta_language.downcase!

      check_lato_blog_post_parent
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

    # This function check that the post parent exist and has not others post for the same language.
    def check_lato_blog_post_parent
      post_parent = LatoBlog::PostParent.find_by(id: self.lato_blog_post_parent_id)
      if !post_parent
        errors.add('Post parent', 'not exist for the post')
        throw :abort
        return
      end

      same_language_post = post_parent.posts.find_by(meta_language: self.meta_language)
      if same_language_post && same_language_post.id != self.id
        errors.add('Post parent', 'has another post for the same language')
        throw :abort
        return
      end
    end

  end
end
