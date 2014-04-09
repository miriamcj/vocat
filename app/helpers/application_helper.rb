module ApplicationHelper

  require 'active_support'

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
      out = { globalFlash: messages }
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

  def debug_current_layout
    controller.send :_layout
  end

  def current_user_role
    myvar = current_user
    if current_user.nil?
      return ''
    else
      return current_user.role
    end
  end

end
