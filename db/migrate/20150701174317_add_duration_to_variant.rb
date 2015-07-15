class AddDurationToVariant < ActiveRecord::Migration
  def change
    add_column :attachment_variants, :duration, :decimal
    add_column :attachment_variants, :width, :integer
    add_column :attachment_variants, :height, :integer
    add_column :attachment_variants, :metadata_saved, :boolean, :default => false
  end
end
