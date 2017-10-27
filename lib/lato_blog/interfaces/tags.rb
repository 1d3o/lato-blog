module LatoBlog
  
  # This module contains a list of functions used to manage tags for the blog.
  module Interface::Tags

    # This function cleans all old tag parents without any child.
    def blog__clean_tag_parents
      tag_parents = LatoBlog::TagParent.all
      tag_parents.map { |tp| tp.destroy if tp.tags.empty? }
    end

    # This function returns an object with the list of tags with some filters.
    def blog__get_tags(
      order: nil,
      language: nil,
      search: nil,
      page: nil,
      per_page: nil
    )
      tags = LatoBlog::Tag.all

      # apply filters
      order = order && order == 'ASC' ? 'ASC' : 'DESC'
      tags = _tags_filter_by_order(tags, order)
      tags = _tags_filter_by_language(tags, language)
      tags = _tags_filter_search(tags, search)

      # take tags uniqueness
      tags = tags.uniq(&:id)

      # save total tags
      total = tags.length

      # manage pagination
      page = page&.to_i || 1
      per_page = per_page&.to_i || 20
      tags = core__paginate_array(tags, per_page, page)

      # return result
      {
        tags: tags && !tags.empty? ? tags.map(&:serialize) : [],
        page: page,
        per_page: per_page,
        order: order,
        total: total
      }
    end

    # This function returns a single category searched by id or permalink.
    def blog__get_category(id: nil, permalink: nil)
      return {} unless id || permalink

      if id
        category = LatoBlog::Category.find_by(id: id.to_i)
      else
        category = LatoBlog::Category.find_by(meta_permalink: permalink)
      end

      category.serialize
    end

    private

    def _tags_filter_by_order(tags, order)
      tags.order("title #{order}")
    end

    def _tags_filter_by_language(tags, language)
      return tags unless language
      tags.where(meta_language: language)
    end

    def _tags_filter_search(tags, search)
      return tags unless search
      tags.where('title like ?', "%#{search}%")
    end

  end
end
  