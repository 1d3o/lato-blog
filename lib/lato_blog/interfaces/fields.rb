module LatoBlog

  module Interface::Fields

    # This function syncronizes the config post fields with the post
    # fields on database.
    def blog__sync_config_post_fields_with_db_post_fields
      posts = LatoBlog::Post.all
      # create / update fields on database
      posts.map { |p| blog__sync_config_post_fields_with_db_post_fields_for_post(p) }
      # remove fields on database
      blog_sync_db_post_fields_with_config_post_fields
    end

    # This function syncronizes the config post fields with the post fields
    # on database for a single post object.
    def blog__sync_config_post_fields_with_db_post_fields_for_post(post)
      post_fields = CONFIGS[:lato_blog][:post_fields]
      # save or update post fields from config
      post_fields.map { |key, content| sync_config_post_field(post, key, content) }
    end

    # This function updates the database post fields with the config
    # post fields.
    def blog_sync_db_post_fields_with_config_post_fields
      # post_fields = CONFIGS[:lato_blog][:post_fields]
      # db_post_fields = LatoBlog::PostField.visibles.roots
      # db_post_fields.each do |db_post_field|
      #   unless post_fields.keys.include?(db_post_field.key)
      #     db_post_field.update(meta_visible: false)
      #   end
      # end

      # TODO: Tenere in considerazione:
      # - aggiornamento delle categorie di appartenenza del field.
      # - eliminazione di field foglie su field composti.
    end

    private

    # This function syncronizes a single post field of a specific post with database.
    def sync_config_post_field(post, key, content)
      db_post_field = LatoBlog::PostField.find_by(
        key: key,
        lato_blog_post_id: post.id,
        lato_blog_post_field_id: nil
      ) # search first level fields

      if db_post_field
        db_post_field.update(meta_visible: true)
        update_db_post_field(db_post_field, content)
      else
        create_db_post_field(post, key, content)
      end
    end

    # Manage single field functions:
    # **************************************************************************

    # This function creates a new db post field from a specific content.
    def create_db_post_field(post, key, content, post_field_parent = nil)
      # check if post field can be created for the post
      categories = content[:categories] && content[:categories].empty? ? nil : content[:categories]
      db_categories = LatoBlog::Category.where(meta_permalink: categories)
      return if categories && !post.categories.include?(db_categories)
      # create post field on database
      db_post_field = LatoBlog::PostField.new(
        key: key,
        typology: content[:type],
        meta_visible: true,
        lato_blog_post_id: post.id,
        lato_blog_post_field_id: post_field_parent ? post_field_parent.id : nil
      )
      throw "Impossible to create post field #{key}" unless db_post_field.save
      # update post field with correct content
      update_db_post_field(db_post_field, content, post_field_parent)
    end

    # This function update an existing post field on database with new content.
    def update_db_post_field(db_post_field, content, post_field_parent = nil)
      case db_post_field.typology
      when 'text'
        update_db_post_field_text(db_post_field, content, post_field_parent)
      when 'composed'
        update_db_post_field_composed(db_post_field, content, post_field_parent)
      end
    end

    # Manage single specific field functions:
    # **************************************************************************

    # Text.
    def update_db_post_field_text(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Composed.
    def update_db_post_field_composed(db_post_field, content, post_field_parent = nil)
      # update the main field
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
      # create or update child fields
      return unless content[:fields]
      content[:fields].each do |child_key, child_content|
        child_db_post_field = LatoBlog::PostField.find_by(
          key: child_key,
          lato_blog_post_id: db_post_field.post.id,
          lato_blog_post_field_id: db_post_field.id
        )
        if child_db_post_field
          update_db_post_field(child_db_post_field, child_content, db_post_field)
        else
          create_db_post_field(db_post_field.post, child_key, child_content, db_post_field)
        end
      end
    end

  end

end