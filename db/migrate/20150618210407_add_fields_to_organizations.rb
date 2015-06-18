class AddFieldsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :subdomain, :string
    add_column :organizations, :active, :boolean
  end
end
