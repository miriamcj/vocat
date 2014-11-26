class Statistics

  def self.admin_stats
    out = [
      {:label => "Logins Within Last 30 Days", :value => User.where('last_sign_in_at >= ?', 1.week.ago).count},
      {:label => "Courses", :value => Course.count},
      {:label => "Users", :value => User.count},
      {:label => "Assets", :value => Asset.count},
      {:label => "Annotations", :value => Annotation.count},
      {:label => "Discussion Posts", :value => DiscussionPost.count},
    ]
    out
  end

end
