# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170529071924) do

  create_table "lato_blog_categories", force: :cascade do |t|
    t.string "title"
    t.string "meta_permalink"
    t.string "meta_language"
    t.integer "lato_core_superuser_creator_id"
    t.integer "lato_blog_category_parent_id"
    t.integer "lato_blog_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_blog_category_parents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_blog_category_posts", force: :cascade do |t|
    t.integer "lato_blog_category_id"
    t.integer "lato_blog_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_blog_post_fields", force: :cascade do |t|
    t.integer "lato_blog_post_id"
    t.string "typology"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_blog_post_parents", force: :cascade do |t|
    t.datetime "publication_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_blog_posts", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "excerpt"
    t.text "content"
    t.string "meta_permalink"
    t.string "meta_status"
    t.string "meta_language"
    t.integer "lato_core_superuser_creator_id"
    t.integer "lato_blog_post_parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_core_superusers", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.text "biography"
    t.string "username"
    t.string "email"
    t.integer "permission"
    t.datetime "last_login_datetime"
    t.string "last_login_ip_address"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_media_media", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
