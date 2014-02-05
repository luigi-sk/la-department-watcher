# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140205181127) do

  create_table "la_department_watcher_departments", :force => true do |t|
    t.string   "departmentid"
    t.string   "name"
    t.string   "onlinestatus"
    t.string   "presetstatus"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "la_department_watcher_departments", ["created_at"], :name => "index_la_department_watcher_departments_on_created_at"
  add_index "la_department_watcher_departments", ["departmentid"], :name => "index_la_department_watcher_departments_on_departmentid"
  add_index "la_department_watcher_departments", ["onlinestatus"], :name => "index_la_department_watcher_departments_on_onlinestatus"

  create_table "la_department_watcher_events", :force => true do |t|
    t.string   "type"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "text_description"
    t.datetime "notify_sent_at"
    t.string   "notify_sent_to"
    t.text     "agents_statuses_json"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "department_id"
  end

  add_index "la_department_watcher_events", ["department_id"], :name => "index_la_department_watcher_events_on_department_id"

end
