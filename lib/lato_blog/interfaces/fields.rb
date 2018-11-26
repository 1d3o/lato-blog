module LatoBlog

  module Interface::Fields

    # This function syncronizes the config post fields with the post
    # fields on database.
    def blog__sync_config_post_fields_with_db_post_fields
      posts = LatoBlog::Post.all
      # create / update fields on database
      posts.map { |p| blog__sync_config_post_fields_with_db_post_fields_for_post(p) }
    end

    # This function syncronizes the config post fields with the post fields
    # on database for a single post object.
    def blog__sync_config_post_fields_with_db_post_fields_for_post(post)
      # save or update post fields from config
      post_fields = CONFIGS[:lato_blog][:post_fields]
      post_fields.map { |key, content| blog__sync_config_post_field(post, key, content) }
      # remove old post fields
      db_post_fields = post.post_fields.visibles.roots
      db_post_fields.map { |dbpf| blog__sync_db_post_field(post, dbpf) }
    end

    # This function syncronizes a single post field of a specific post with database.
    def blog__sync_config_post_field(post, key, content)
      db_post_field = LatoBlog::PostField.find_by(
        key: key,
        lato_blog_post_id: post.id,
        lato_blog_post_field_id: nil
      )
      # check if post field can be created for the post
      if content[:categories] && !content[:categories].empty?
        db_categories = LatoBlog::Category.where(meta_permalink: content[:categories])
        return if (post.categories.pluck(:id) & db_categories.pluck(:id)).empty?
      end
      # run correct action for field
      if db_post_field
        blog__update_db_post_field(db_post_field, content)
      else
        blog__create_db_post_field(post, key, content)
      end
    end

    # This function syncronizes a single post field of a specific post with config file.
    def blog__sync_db_post_field(post, db_post_field)
      post_fields = CONFIGS[:lato_blog][:post_fields]
      # search db post field on config file
      content = post_fields[db_post_field.key]
      db_post_field.update(meta_visible: false) && return unless content
      # check category of post field is accepted
      if content[:categories] && !content[:categories].empty?
        db_categories = LatoBlog::Category.where(meta_permalink: content[:categories])
        db_post_field.update(meta_visible: false) && return if (post.categories.pluck(:id) & db_categories.pluck(:id)).empty?
      end
    end

    # Manage single field functions:
    # **************************************************************************

    # This function creates a new db post field from a specific content.
    def blog__create_db_post_field(post, key, content, post_field_parent = nil)
      # create post field on database
      db_post_field = LatoBlog::PostField.new(
        key: key,
        typology: content[:type],
        lato_blog_post_id: post.id,
        lato_blog_post_field_id: post_field_parent ? post_field_parent.id : nil
      )
      throw "Impossible to create post field #{key}" unless db_post_field.save
      # update post field with correct content
      blog__update_db_post_field(db_post_field, content, post_field_parent)
    end

    # This function update an existing post field on database with new content.
    def blog__update_db_post_field(db_post_field, content, post_field_parent = nil)
      # run minimum updates
      db_post_field.update(
        position: content[:position],
        meta_visible: true
      )
      # run custom update for type
      case db_post_field.typology
      when 'text'
        update_db_post_field_text(db_post_field, content, post_field_parent)
      when 'textarea'
        update_db_post_field_textarea(db_post_field, content, post_field_parent)
      when 'datetime'
        update_db_post_field_datetime(db_post_field, content, post_field_parent)
      when 'editor'
        update_db_post_field_editor(db_post_field, content, post_field_parent)
      when 'geolocalization'
        update_db_post_field_geolocalization(db_post_field, content, post_field_parent)
      when 'image'
        update_db_post_field_image(db_post_field, content, post_field_parent)
      when 'gallery'
        update_db_post_field_gallery(db_post_field, content, post_field_parent)
      when 'youtube'
        update_db_post_field_youtube(db_post_field, content, post_field_parent)
      when 'composed'
        update_db_post_field_composed(db_post_field, content, post_field_parent)
      when 'relay'
        update_db_post_field_relay(db_post_field, content, post_field_parent)
      end
    end

    private

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

    # Textarea.
    def update_db_post_field_textarea(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Datetime.
    def update_db_post_field_datetime(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Editor.
    def update_db_post_field_editor(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Geolocalization.
    def update_db_post_field_geolocalization(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Image.
    def update_db_post_field_image(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Gallery.
    def update_db_post_field_gallery(db_post_field, content, post_field_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil
        }
      )
    end

    # Youtube.
    def update_db_post_field_youtube(db_post_field, content, post_field_parent = nil)
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
        # search child field on db
        child_db_post_field = LatoBlog::PostField.find_by(
          key: child_key,
          lato_blog_post_id: db_post_field.post.id,
          lato_blog_post_field_id: db_post_field.id
        )
        # update or create child field on db
        if child_db_post_field
          blog__update_db_post_field(child_db_post_field, child_content, db_post_field)
        else
          blog__create_db_post_field(db_post_field.post, child_key, child_content, db_post_field)
        end
      end
    end

    # Relay.
    def update_db_post_field_relay(db_post_field, content, post_parent = nil)
      db_post_field.update(
        meta_datas: {
          label: content[:label] && !content[:label].blank? ? content[:label] : db_post_field.key,
          class: content[:class] && !content[:class].blank? ? content[:class] : nil,
          fields: content[:fields] && !content[:fields].empty? ? content[:fields] : nil
        }
      )
    end

  end

end