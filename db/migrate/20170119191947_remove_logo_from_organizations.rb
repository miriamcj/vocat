class RemoveLogoFromOrganizations < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :logo
  end
end
