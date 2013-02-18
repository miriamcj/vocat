class Snapshot1 < ActiveRecord::Migration
  def up

    # ATTACHMENTS
    create_table :attachments, :force => true do |t|
      t.attachment :media
      t.integer  :transcoding_status, :default => 0
      t.string   :transcoding_error
      t.integer  :fileable_id
      t.string   :fileable_type

      t.timestamps
    end

    add_index :attachments, [:fileable_id, :fileable_type]

    # COURSES
    create_table :courses, :force => true do |t|
      t.string :name
      t.string :department
      t.string :number
      t.string :section
      t.text :description
      t.references :organization

      t.timestamps
    end

    add_index :courses, :organization_id

    # DELAYED JOBS
    create_table :delayed_jobs, :force => true do |t|
      t.integer  :priority,   :default => 0
      t.integer  :attempts,   :default => 0
      t.text     :handler
      t.text     :last_error
      t.datetime :run_at
      t.datetime :locked_at
      t.datetime :failed_at
      t.string   :locked_by
      t.string   :queue

      t.timestamps
    end

    add_index :delayed_jobs, [:priority, :run_at], :name => "delayed_jobs_priority"

    # ORGANIZATIONS
    create_table :organizations, :force => true do |t|
      t.string :name

      t.timestamps
    end

    # SUBMISSIONS
    create_table :submissions, :force => true do |t|
      t.string   :name
      t.text     :summary

      t.timestamps
    end

    # USERS (devise)
    create_table :users, :force => true do |t|
      t.string   :email,                  :default => "", :null => false
      t.string   :encrypted_password,     :default => "", :null => false
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count,          :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :users, [:email], :unique => true
    add_index :users, [:reset_password_token], :unique => true
  end
end
