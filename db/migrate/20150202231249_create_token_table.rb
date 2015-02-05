class CreateTokenTable < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :user_id
      t.integer :refresh_count, :default => 0
      t.string :ip_address
      t.string :client
      t.datetime :last_seen_at
      t.datetime :expires_at
      t.string :token
    end
  end
end
