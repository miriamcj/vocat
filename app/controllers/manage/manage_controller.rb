class Manage::ManageController < ApplicationController

  include Concerns::ManageConcerns


  def index
    @stats = [
        {
            :label => 'Active Organizations',
            :value => Organization.where(:active => true).count
        },
        {
            :label => 'Inactive Organizations',
            :value => Organization.where(:active => false).count
        }

    ]
  end

  private




end