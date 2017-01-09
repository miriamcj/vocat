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
    "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
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
    course_role = course.role(user)
    user_role = user.role
    if course_role == :evaluator || course_role == :assistant || course_role == :administrator || user.role == 'superadministrator'
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

  def evaluator_or_admin?
    current_user_role == 'administrator' || current_user_role == 'evaluator' ? true : false
  end

  def size_and_unit_from_number(value)
    value = value.to_f
    conv={
        1024=>'B',
        1024*1024=>'KB',
        1024*1024*1024=>'MB',
        1024*1024*1024*1024=>'GB',
        1024*1024*1024*1024*1024=>'TB',
        1024*1024*1024*1024*1024*1024=>'PB',
        1024*1024*1024*1024*1024*1024*1024=>'EB'
    }
    conv.keys.sort.each { |mult|
      next if value >= mult
      suffix = conv[mult]
      return [ (value / (mult / 1024)).round(2), suffix ]
    }
  end

  def sortable_header(params, column, sorting = nil)
    sorting = sorting || column.downcase
    current_sorting = params[:sorting]
    current_direction = params[:direction]
    next_direction = case current_direction
                       when "ASC" then "DESC"
                       when "DESC" then "ASC"
                       else "ASC"
                     end
    classname = "sort-none"
    if current_sorting == sorting
      classname = case current_direction
                    when "ASC" then "sort-ascending"
                    when "DESC" then "sort-descending"
                    else "sort-none"
                  end
    end
    link_to(column, { page: params[:page], sorting: sorting, direction: next_direction }, class: classname)
  end

end
