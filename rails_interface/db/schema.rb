# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "status"
    t.string   "project_id"
    t.text     "comments"
    t.text     "access_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_started", :default => '2008-04-25'
  end

end
