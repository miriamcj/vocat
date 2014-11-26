class AddAssetIdToAnnotations < ActiveRecord::Migration
  def change
    add_column :annotations, :asset_id, :integer
  end
end
