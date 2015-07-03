class Statistics

  def self.admin_stats(organization)
    out = [
        {:label => "Logins Within Last 30 Days", :value => organization.users.where('last_sign_in_at >= ?', 1.week.ago).count},
        {:label => "Courses", :value => organization.courses.count},
        {:label => "Users", :value => organization.users.count},
        # TODO: These queries need to account for organization.
        {:label => "Assets", :value => Asset.count},
        {:label => "Annotations", :value => Annotation.count},
        {:label => "Discussion Posts", :value => DiscussionPost.count},
    ]
    out
  end

  def self.admin_asset_stats(organization)
    storage_value = Attachment.in_organization(organization).created_this_month.sum(:media_file_size) + Attachment::Variant.in_organization(organization).created_this_month.sum(:file_size)
    transcoded_value = Attachment::Variant.in_organization(organization).created_this_month.sum(:duration)
    out = [
      {:label => "New Asset Size", :value => storage_value, :is_file_size => true },
      {:label => "Assets Created", :value => Asset.created_this_month.count },
      {:label => "Minutes Transcoded", :value => transcoded_value }
    ]
    out
  end

  def self.manage_org_stats()
    out = [
        {
            :label => 'Active Organizations',
            :value => Organization.where(:active => true).count
        },
        {
            :label => 'Inactive Organizations',
            :value => Organization.where(:active => false).count
        },
        {
            :label => "#{Date.today.strftime("%B %Y")} Storage",
            :value => Attachment.created_this_month.sum(:media_file_size) + Attachment::Variant.created_this_month.sum(:file_size),
            :is_file_size => true
        },
        {
            :label => "#{Date.today.strftime("%B %Y")} Minutes Transcoded",
            :value => Attachment::Variant.created_this_month.sum(:duration),
            :unit => 'Minutes'
        }

    ]
    out
  end

end
