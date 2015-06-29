module ApplicationHelper

  require 'active_support'

  def project_submission_detail_path(project, user)
    if project.type == 'UserProject'
      course_user_creator_project_detail_path(project.course, user, project)
    elsif project.type == 'GroupProject'
      course_group_creator_project_detail_path(project.course, user, project)
    end
  end

  def submission_detail_path(submission)
    if submission.creator_type == 'Group'
      course_group_creator_project_detail_path(submission.course, submission.creator, submission.project)
    elsif submission.creator_type == 'User'
      course_user_creator_project_detail_path(submission.course, submission.creator, submission.project)
    end
  end

  def serialize_for_bootstrap(data, current_user)
    if data.is_a?(Array)
      # See https://github.com/evrone/active_model_serializers/commit/22b6a74131682f086bd8095aaaf22d0cd6e8616d
      ActiveModel::ArraySerializer.new(data, :scope => current_user).to_json()
    else
      out = data.active_model_serializer.new(data, :scope => current_user, :root => false).to_json()
    end
  end

  def round(float, precision = 1)
    if float.nil?
      0
    else
      "%.#{precision}f" % float
    end
  end

  def serialize_flash()
    if flash.any?
      messages = []
      flash.each do |level, msg|
        msg = {
            level: level,
            msg: msg,
            no_fade: true
        }
        messages << msg
      end
      out = {globalFlash: messages}
      out.to_json()
    end
  end

  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  def avatar_url(user, size)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
  end

  def possessive(string)
    suffix = if string.downcase == 'it'
               "s"
             elsif string.downcase == 'who'
               'se'
             elsif string.end_with?('s')
               "'"
             else
               "'s"
             end
    string + suffix
  end

  def debug_current_layout
    controller.send :_layout
  end

  def user_course_url(user, course)
    role = course.role(user)
    if role == :evaluator || role == :assistant || role == :administrator
      url_for course_path(course)
    else
      url_for portfolio_course_path(course)
    end
  end

  def current_user_role
    if current_user.nil?
      return ''
    else
      return current_user.role
    end
  end

end
