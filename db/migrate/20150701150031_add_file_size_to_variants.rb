class AddFileSizeToVariants < ActiveRecord::Migration
  def change
    add_column :attachment_variants, :file_size, :integer
  end
end
