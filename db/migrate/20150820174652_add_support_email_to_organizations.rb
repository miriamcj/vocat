class AddSupportEmailToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :support_email, :string
  end
end
