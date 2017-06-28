include LatoBlog::Interface

# set languages identifier.
BLOG_LANGUAGES_IDENTIFIER = blog__get_languages_identifier

# set posts possible status.
BLOG_POSTS_STATUS = {
  deleted: 'deleted',
  drafted: 'drafted',
  published: 'published'
}

# create default category.
if ActiveRecord::Base.connection.table_exists?('lato_blog_category_parents') &&
   ActiveRecord::Base.connection.table_exists?('lato_blog_categories')
  blog__create_default_category
end

# sync config fields with primary fields.
if ActiveRecord::Base.connection.table_exists?('lato_blog_post_fields')
  blog__sync_config_post_fields_with_db_post_fields
end
