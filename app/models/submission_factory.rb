class SubmissionFactory

  def course(course)
    group_project_ids = course.group_projects.pluck(:id)
    user_project_ids = course.user_projects.pluck(:id)
    user_ids = course.creators.pluck(:id)
    group_ids = course.groups.pluck(:id)
    group_submissions = group_project_ids.product group_ids
    user_submissions = user_project_ids.product user_ids
    create_absent_group_submissions(group_submissions)
    create_absent_user_submissions(user_submissions)
    course.submissions
  end

  def course_and_creator(course, creator)
    user_ids, group_ids = get_user_and_group_ids_for_creator(course, creator)
    group_project_ids = course.group_projects.pluck(:id) + course.open_projects.pluck(:id)
    user_project_ids = course.user_projects.pluck(:id) + course.open_projects.pluck(:id)
    group_submissions = group_project_ids.product group_ids
    user_submissions = user_project_ids.product user_ids
    create_absent_group_submissions(group_submissions)
    create_absent_user_submissions(user_submissions)
    submission_query(user_project_ids, user_ids, group_project_ids, group_ids)
  end

  def creator_and_project(creator, project)
    group_project_ids = []
    user_project_ids = []
    user_ids, group_ids = get_user_and_group_ids_for_creator(project.course, creator)
    if project.is_group_project?
      group_project_ids = [project.id]
      group_submissions = group_project_ids.product group_ids
      create_absent_group_submissions(group_submissions)
    end
    if project.is_user_project?
      user_project_ids = [project.id]
      user_submissions = user_project_ids.product user_ids
      create_absent_user_submissions(user_submissions)
    end
    submission_query(user_project_ids, user_ids, group_project_ids, group_ids)
  end

  def project(project)
    course = project.course
    project_ids = [project.id]
    if project.is_group_project?
      group_ids = course.groups.pluck :id
      group_submissions = project_ids.product group_ids
      create_absent_group_submissions(group_submissions)
    end
    if project.is_user_project?
      user_ids = course.creators.pluck :id
      user_submissions = project_ids.product user_ids
      create_absent_user_submissions(user_submissions)
    end
    project.submissions
  end

  protected

  def submission_query(user_project_ids, user_ids, group_project_ids, group_ids)
    Submission.where("
      (project_id in (?) AND creator_id in (?) AND creator_type = 'User')
      OR
      (project_id in (?) AND creator_id in (?) AND creator_type = 'Group')
    ", user_project_ids, user_ids, group_project_ids, group_ids)
  end

  def get_user_and_group_ids_for_creator(course, creator)
    user_ids = []
    group_ids = []
    if creator.instance_of?(User)
      user_ids = [creator.id]
      group_ids = creator.groups.where(course: course).pluck :id
    elsif creator.instance_of?(Group)
      user_ids = []
      group_ids = [creator.id]
    end
    [user_ids, group_ids]
  end

  # Group submissions is an array of arrays; in each array, 0 => project_id and 1 => group_id
  def create_absent_group_submissions(all_group_submissions)
    existing_group_submissions = Submission.where(:creator_type => 'Group').pluck(:project_id, :creator_id)
    new_submissions = all_group_submissions - existing_group_submissions
    new_submissions.each do |ids|
      submission =Submission.create({
           :project_id => ids[0],
           :creator_id => ids[1],
           :creator_type => 'Group'
       })
    end
  end

  def create_absent_user_submissions(all_user_submissions)
    existing_user_submissions = Submission.where(:creator_type => 'User').pluck(:project_id, :creator_id)
    new_submissions = all_user_submissions - existing_user_submissions
    new_submissions.each do |ids|
      submission = Submission.create({
          :project_id => ids[0],
          :creator_id => ids[1],
          :creator_type => 'User'
      })
    end
  end

end