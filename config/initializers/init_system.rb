include LatoBlog::Interface

# set languages identifier.
BLOG_LANGUAGES_IDENTIFIER = blog__get_languages_identifier

# set posts possible status.
BLOG_POSTS_STATUS = {
  deleted: 'deleted',
  drafted: 'drafted',
  published: 'published'
}

# create post fields for current posts.
if ActiveRecord::Base.connection.table_exists? 'lato_blog_post_fields'
  blog__manage_posts_fields # update fields from config file
end
