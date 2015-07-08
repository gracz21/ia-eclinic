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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150708102645) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "appointments", force: true do |t|
    t.integer  "patient_id"
    t.integer  "assignment_id"
    t.date     "day"
    t.time     "hour"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "confirmed",     default: false, null: false
  end

  add_index "appointments", ["assignment_id"], name: "index_appointments_on_assignment_id"
  add_index "appointments", ["patient_id"], name: "index_appointments_on_patient_id"

  create_table "assignments", force: true do |t|
    t.integer  "clinic_id"
    t.integer  "doctor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "assignments", ["clinic_id"], name: "index_assignments_on_clinic_id"
  add_index "assignments", ["doctor_id"], name: "index_assignments_on_doctor_id"

  create_table "clinics", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "pwz"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "doctors", ["email"], name: "index_doctors_on_email", unique: true
  add_index "doctors", ["reset_password_token"], name: "index_doctors_on_reset_password_token", unique: true

  create_table "patients", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pesel"
    t.string   "address"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "approved",               default: false, null: false
  end

  add_index "patients", ["approved"], name: "index_patients_on_approved"
  add_index "patients", ["email"], name: "index_patients_on_email", unique: true
  add_index "patients", ["reset_password_token"], name: "index_patients_on_reset_password_token", unique: true

  create_table "schedules", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "weekday"
    t.time     "start_hour"
    t.time     "end_hour"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "schedules", ["assignment_id"], name: "index_schedules_on_assignment_id"

end
