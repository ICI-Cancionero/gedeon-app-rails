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

ActiveRecord::Schema[7.0].define(version: 2024_02_18_182313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_accounts_on_subdomain"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_admin_users_on_account_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "playlist_items", force: :cascade do |t|
    t.integer "position"
    t.bigint "song_id"
    t.bigint "playlist_section_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["playlist_section_id"], name: "index_playlist_items_on_playlist_section_id"
    t.index ["song_id"], name: "index_playlist_items_on_song_id"
  end

  create_table "playlist_sections", force: :cascade do |t|
    t.string "name", default: ""
    t.bigint "playlist_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["playlist_id"], name: "index_playlist_sections_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_playlists_on_account_id"
  end

  create_table "playlists_songs", force: :cascade do |t|
    t.bigint "playlist_id"
    t.bigint "song_id"
    t.index ["playlist_id"], name: "index_playlists_songs_on_playlist_id"
    t.index ["song_id"], name: "index_playlists_songs_on_song_id"
  end

  create_table "scriptures", force: :cascade do |t|
    t.string "book_id"
    t.string "chapter_num"
    t.text "verses"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.bigint "playlist_section_id"
    t.integer "from"
    t.integer "to"
    t.string "bible_version"
    t.index ["account_id"], name: "index_scriptures_on_account_id"
    t.index ["playlist_section_id"], name: "index_scriptures_on_playlist_section_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_songs_on_account_id"
  end

  create_table "songs_video_links", id: false, force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "video_link_id", null: false
    t.index ["song_id"], name: "index_songs_video_links_on_song_id"
    t.index ["video_link_id"], name: "index_songs_video_links_on_video_link_id"
  end

  create_table "video_links", force: :cascade do |t|
    t.string "url", null: false
    t.integer "provider", default: 0, null: false
    t.string "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admin_users", "accounts"
  add_foreign_key "playlists", "accounts"
  add_foreign_key "scriptures", "accounts"
  add_foreign_key "songs", "accounts"
end
