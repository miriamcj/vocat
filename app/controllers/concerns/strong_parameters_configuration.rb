module Concerns::StrongParametersConfiguration
  extend ActiveSupport::Concern

  included do
    # If we're in a devise controller, whitelist some parameters
    before_action :configure_permitted_parameters, if: :devise_controller?
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [
        :first_name,
        :last_name,
        :settings,
        :city,
        :state,
        :country,
        :gender,
        :avatar,
        :avatar_delete
    ])
  end

  protected

  def key_params
    params.require(:user).permit(:email, :password)
  end

  def course_request_params
    params.require(:course_request).permit(:name,
                                           :department,
                                           :section,
                                           :year,
                                           :semester_id,
                                           :number
    )
  end


  def project_params(type = 'project')
    params[type.to_sym][:allowed_attachment_families] ||= []
    params[type.to_sym][:allowed_attachment_families].reject! { |f| f.empty? }
    params.require(type.to_sym).permit(:name,
                                       :description,
                                       :course_id,
                                       :rubric_id,
                                       :type,
                                       :listing_order_position,
                                       {:allowed_attachment_families => []},
                                       :due_date,
                                       :settings => [
                                           Project::ALLOWED_SETTINGS
                                       ]
    ).merge({listing_order_position: params[:listing_order_position]})

  end

  def token_params
    params.require(:user).permit(:email, :password)
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :middle_name,
                                 :last_name,
                                 :password,
                                 :password_confirmation,
                                 :email,
                                 :city,
                                 :state,
                                 :country,
                                 :gender
    )
  end

  def course_params
    params.require(:course).permit(:id,
                                   :department,
                                   :number,
                                   :section,
                                   :year,
                                   :description,
                                   :semester_id,
                                   :name,
                                   :message,
                                   :groups_attributes => [:id,
                                                          :name,
                                                          :creator_ids => []
                                   ]
    )
  end

  def group_params
    params[:group][:creator_ids] = params[:creator_ids]
    params.require(:group).permit(:name,
                                  :course_id,
                                  :creator_ids => []
    )
  end

  def annotation_params
    params.require(:annotation).permit(:body,
                                       :canvas,
                                       :smpte_timecode,
                                       :published,
                                       :seconds_timecode,
                                       :asset_id
    )
  end

  def attachment_params
    params.require(:attachment).permit(:media_file_name)
  end

  def asset_params
    params.require(:asset).permit(:id,
                                  :submission_id,
                                  :listing_order_position,
                                  :name,
                                  :external_source,
                                  :external_location,
                                  :attachment_attributes => [:id]
    )
  end

  def video_params
    params.require(:video).permit(:submission_id,
                                  :name,
                                  :source,
                                  attachment_attributes: :media
    )
  end

  def discussion_post_params
    params.require(:discussion_post).permit(:published,
                                            :parent_id,
                                            :submission_id,
                                            :body
    )
  end

  def evaluation_params
    params.require(:evaluation).permit(:submission_id,
                                       :published
    ).tap do |whitelisted|
      whitelisted[:scores] = params.to_unsafe_h[:scores]
    end
  end

  def admin_rubric_params
    params.require(:rubric).permit(:name,
                                   :description,
                                   :cells,
                                   :fields,
                                   :ranges,
                                   :high,
                                   :public,
                                   :low
    ).tap do |whitelisted|
      whitelisted[:ranges] = params.to_unsafe_h[:ranges]
      whitelisted[:fields] = params.to_unsafe_h[:fields]
      whitelisted[:cells] = params.to_unsafe_h[:cells]
    end
  end

  def non_admin_rubric_params
    params.require(:rubric).permit(:name,
                                   :description,
                                   :cells,
                                   :fields,
                                   :ranges,
                                   :high,
                                   :low
    ).tap do |whitelisted|
      whitelisted[:ranges] = params.to_unsafe_h[:ranges]
      whitelisted[:fields] = params.to_unsafe_h[:fields]
      whitelisted[:cells] = params.to_unsafe_h[:cells]
    end
  end

  def organization_params
    params.require(:organization).permit(:name,
                                         :subdomain,
                                         :active,
                                         :ldap_enabled,
                                         :ldap_host,
                                         :ldap_encryption,
                                         :ldap_port,
                                         :ldap_filter_dn,
                                         :ldap_filter,
                                         :ldap_bind_cn,
                                         :ldap_bind_password,
                                         :ldap_org_identity,
                                         :ldap_reset_pw_url,
                                         :ldap_recover_pw_url,
                                         :ldap_message,
                                         :ldap_evaluator_email_domain,
                                         :ldap_default_role,
                                         :email_default_from,
                                         :email_notification_course_request,
                                         :support_email
    )
  end

  def rubric_params
    if current_user.role?('administrator') || current_user.role?('superadministrator')
      admin_rubric_params
    else
      non_admin_rubric_params
    end
  end

  def submission_params
    # TODO: This is a temporary work around to solve the problem where params[:video_attributes] is
    # TODO: not making it into params[:submission][:video_attributes]
    params[:submission][:video_attributes] = params[:video_attributes]
    #params.require(:submission).permit(:name, video_attributes: [:source, :source_id])
    params.require(:submission).permit!
  end

  def visit_params
    params.require(:visit).permit(:visitable_id, :visitable_type, :visitable_course_id, :visitable_submission_id)
  end

end
