module LatoBlog

  # This module contains a list of functions used to manage categories for the blog.
  module Interface::Categories

    # This function create the default category if it not exists.
    def blog__create_default_category
      category_parent = LatoBlog::CategoryParent.find_by(default: true)
      return if category_parent

      category_parent = LatoBlog::CategoryParent.new(default: true)
      throw 'Impossible to create default category parent' unless category_parent.save

      languages = blog__get_languages_identifier
      languages.each do |language|
        category = LatoBlog::Category.new(
          title: 'Default',
          meta_permalink: "default_#{language}",
          meta_language: language,
          lato_core_superuser_creator_id: 1,
          lato_blog_category_parent_id: category_parent.id
        )
        throw 'Impossible to create default category' unless category.save
      end
    end

    # This function cleans all old category parents without any child.
    def blog__clean_category_parents
      category_parents = LatoBlog::CategoryParent.all
      category_parents.map { |cp| cp.destroy if cp.categories.empty? }
    end

  end
end
