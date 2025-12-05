# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_24_074023) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "collection_items", force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "product_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_items_on_collection_id"
    t.index ["product_id"], name: "index_collection_items_on_product_id"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.integer "parent_id"
    t.text "content"
    t.integer "upvotes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["product_id"], name: "index_comments_on_product_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.string "followable_type", null: false
    t.integer "followable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "launches", force: :cascade do |t|
    t.integer "product_id", null: false
    t.datetime "launch_date"
    t.string "region"
    t.integer "status"
    t.datetime "scheduled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_launches_on_product_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_likes_on_product_id"
    t.index ["user_id", "product_id"], name: "index_likes_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "maker_roles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_maker_roles_on_product_id"
    t.index ["user_id"], name: "index_maker_roles_on_user_id"
  end

  create_table "product_topics", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_topics_on_product_id"
    t.index ["topic_id", "product_id"], name: "idx_product_topics_topic_product"
    t.index ["topic_id"], name: "index_product_topics_on_topic_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "tagline"
    t.text "description"
    t.string "website_url"
    t.string "logo_url"
    t.string "cover_url"
    t.text "gallery_urls"
    t.text "pricing_info"
    t.integer "status"
    t.boolean "featured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.text "key_features"
    t.integer "votes_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.string "company_name"
    t.integer "founded_year"
    t.string "headquarters"
    t.string "employee_count"
    t.text "company_description"
    t.index ["comments_count"], name: "index_products_on_comments_count"
    t.index ["likes_count"], name: "index_products_on_likes_count"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["status", "created_at"], name: "idx_products_status_created"
    t.index ["status", "votes_count", "likes_count"], name: "idx_products_popularity"
    t.index ["user_id"], name: "index_products_on_user_id"
    t.index ["votes_count"], name: "index_products_on_votes_count"
  end

  create_table "replies", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "review_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id", "created_at"], name: "index_replies_on_review_id_and_created_at"
    t.index ["review_id"], name: "index_replies_on_review_id"
    t.index ["user_id", "created_at"], name: "index_replies_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.integer "rating", null: false
    t.text "content", null: false
    t.integer "helpful_count", default: 0
    t.integer "reply_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "created_at"], name: "index_reviews_on_product_id_and_created_at"
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["user_id", "created_at"], name: "index_reviews_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.text "description"
    t.string "cover_url"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "emoji"
    t.index ["slug"], name: "idx_topics_slug_unique", unique: true
    t.index ["slug"], name: "index_topics_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "name"
    t.integer "role"
    t.integer "reputation"
    t.text "bio"
    t.string "avatar_url"
    t.string "website"
    t.string "github_url"
    t.string "twitter_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "linkedin_url"
    t.string "job_title"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "user_id"], name: "idx_votes_product_user"
    t.index ["product_id"], name: "index_votes_on_product_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collection_items", "collections"
  add_foreign_key "collection_items", "products"
  add_foreign_key "collections", "users"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "products"
  add_foreign_key "comments", "users"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "launches", "products"
  add_foreign_key "likes", "products"
  add_foreign_key "likes", "users"
  add_foreign_key "maker_roles", "products"
  add_foreign_key "maker_roles", "users"
  add_foreign_key "product_topics", "products"
  add_foreign_key "product_topics", "topics"
  add_foreign_key "products", "users"
  add_foreign_key "replies", "reviews"
  add_foreign_key "replies", "users"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "votes", "products"
  add_foreign_key "votes", "users"
end
