class SubmissionFactory



  def course(course)

    to_create = []
    project_ids = course.projects.pluck(:id)
    creator_ids = course.creators.pluck(:id)
    group_ids = course.groups.pluck(:id)

    existing_submissions = Submission.select([:creator_type, :creator_id, :project_id]).joins(:project).where(:project_id => project_ids).map { |s| {project_id: s.project_id, creator_type: s.creator_type, creator_id: s.creator_id}}
    project_ids.each do |project_id|
      creator_ids.each do |creator_id|
        if existing_submissions.count { |s| s[:project_id] == project_id && s[:creator_id] == creator_id && s[:creator_type] == 'User' } == 0
          missing = { :project_id => project_id, :creator_id => creator_id, :creator_type => 'User' }
          to_create.push missing
        end
      end
      group_ids.each do |creator_id|
        if existing_submissions.count { |s| s[:project_id] == project_id && s[:creator_id] == creator_id && s[:creator_type] == 'Group' } == 0
          missing = { :project_id => project_id, :creator_id => creator_id, :creator_type => 'Group' }
          to_create.push missing
        end
      end
    end
    to_create.each do |create|
      Submission.create({
          :project_id => create[:project_id],
          :creator_id => create[:creator_id],
          :creator_type => create[:creator_type]
      })
    end
    course.submissions
  end

	def course_and_creator(course, creator)
		project_ids = course.projects.pluck(:id)
		creator_submissions = creator.submissions.joins(:project).where(:projects => {:course_id => course})
		submitted_project_ids = creator_submissions.pluck(:project_id)
		(project_ids - submitted_project_ids).each do |project_id|
			Submission.create({
					                  :project_id => project_id,
					                  :creator => creator,
			                  })
		end
		creator_submissions
	end

	def creator_and_project(creator, project)
		submission = Submission.where(:creator_id => creator, :creator_type => creator.class.name, :project_id => project).first_or_create
		[submission]
	end

	def project(project)
    course = project.course
		user_ids = course.creators.pluck(:id)
		group_ids = course.groups.pluck(:id)
		submitted_user_ids = course.submissions.where(:project_id => project, :creator_type => 'User').pluck(:creator_id)
		submitted_group_ids = course.submissions.where(:project_id => project, :creator_type => 'Group').pluck(:creator_id)
		(group_ids - submitted_group_ids).each do |group_id|
			Submission.create({
					                  :project_id => project.id,
					                  :creator_id => group_id,
			                      :creator_type => 'Group'
			                  })
		end
		(user_ids - submitted_user_ids).each do |user_id|
			Submission.create({
					                  :project_id => project.id,
					                  :creator_id => user_id,
					                  :creator_type => 'User'
			                  })
		end
		course.submissions.where(:project_id => project)
	end

end