class MakeSubmissionCreatorPolymorphic < ActiveRecord::Migration
  def up
    add_column :submissions, :creator_type, :string, :default => 'User'
  end

  def down
    remove_column :submissions, :creator_type
  end
end
