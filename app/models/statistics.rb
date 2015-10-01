class Statistics

  def self.admin_stats(organization, search = {})
    out = []
    if search.except(:organization).values.delete_if {|val| val.nil? }.length == 0
      out.push({:label => "Logins Within Last 30 Days", :value => organization.users.where('last_sign_in_at >= ?', 1.week.ago).count})
      out.push({:label => "Users", :value => organization.users.count})
      # TODO: These queries need to account for organization.
      out.push({:label => "Assets", :value => Asset.in_organization(organization).count})
      out.push({:label => "Annotations", :value => Annotation.in_organization(organization).count})
      out.push({:label => "Discussion Posts", :value => DiscussionPost.in_organization(organization).count})
    else
      courses = organization.courses.search(search)
      out.push({:label => "Creators", :value => Membership.in_courses(courses).creators.count})
      out.push({:label => "Assets", :value => Asset.in_courses(courses).count})
      out.push({:label => "Annotations", :value => Annotation.in_courses(courses).count})
      out.push({:label => "Discussion Posts", :value => DiscussionPost.in_courses(courses).count})
    end
    out.push({:label => "Courses", :value => organization.courses.search(search).count})
    out
  end

  def self.admin_asset_stats(organization)
    storage_value = Attachment.in_organization(organization).created_this_month.sum(:media_file_size) + Attachment::Variant.in_organization(organization).created_this_month.sum(:file_size)
    transcoded_value = Attachment::Variant.in_organization(organization).created_this_month.sum(:duration)
    out = [
      {:label => "New Storage This Month", :value => storage_value, :is_file_size => true },
      {:label => "Assets Created", :value => Asset.created_this_month.count },
      {:label => "Minutes Transcoded", :value => transcoded_value }
    ]
    out
  end

  def self.single_organization_stats(organization)
    out = [
        {:label => "Creators", :value => User.creators.in_org(organization).count, :class => 'summary-box-creator' },
        {:label => "Evaluators", :value => User.evaluators.in_org(organization).count, :class => 'summary-box-evaluator' },
        {:label => "Courses", :value => Course.in_org(organization).count },
        {:label => "Assets", :value => Asset.in_organization(organization).count }
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
