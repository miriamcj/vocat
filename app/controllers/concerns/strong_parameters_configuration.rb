module StrongParametersConfiguration
  extend ActiveSupport::Concern

  included do
    # If we're in a devise controller, whitelist some parameters
    before_action :configure_permitted_parameters, if: :devise_controller?

    # This is a bit of a hack to deal with incompatibilities between CanCan 1.x and Rails 4 strong
    # parameters protection. Basically, CanCan attempts to access the params directly when it loads
    # the resource. This work-around (see https://github.com/ryanb/cancan/issues/835#issuecomment-18663815)
    # looks for a params filtering method named after the resource and assigns the results of that method
    # to the corresponding entry in params.
    before_action do
      if respond_to?('cancan_params_method_override', true)
        method = 'cancan_params_method_override'
      else
        resource = controller_name.singularize.to_sym
        method = "#{resource}_params"
      end
      params[resource] &&= send(method) if respond_to?(method, true)
    end

  end



  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :first_name
    devise_parameter_sanitizer.for(:account_update) << :last_name
    devise_parameter_sanitizer.for(:account_update) << :settings
    devise_parameter_sanitizer.for(:account_update) << :city
    devise_parameter_sanitizer.for(:account_update) << :state
    devise_parameter_sanitizer.for(:account_update) << :country
    devise_parameter_sanitizer.for(:account_update) << :gender
  end

  protected


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
                                       :due_date
    ).merge({ listing_order_position: params[:listing_order_position]})

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
                                   :groups_attributes => [ :id,
                                                           :name,
                                                           :creator_ids => []
                                   ],
                                   :settings => [
                                       Course::ALLOWED_SETTINGS
                                   ]
    )
  end

  def group_params
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
      whitelisted[:scores] = params[:evaluation][:scores]
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
      whitelisted[:ranges] = params[:rubric][:ranges]
      whitelisted[:fields] = params[:rubric][:fields]
      whitelisted[:cells] = params[:rubric][:cells]
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
      whitelisted[:ranges] = params[:rubric][:ranges]
      whitelisted[:fields] = params[:rubric][:fields]
      whitelisted[:cells] = params[:rubric][:cells]
    end
  end

  def rubric_params
    if current_user.role?('administrator')
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

end
