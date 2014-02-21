class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'frames'

  check_authorization :unless => :devise_controller?

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :test_flash_messages
  before_filter :authenticate_user!
  before_filter :inject_global_layout_variables
  before_filter :inject_session_data
  before_filter :inject_aws_info
  before_filter :get_organization_and_current_course

  # This is a bit of a hack to deal with incompatibilities between CanCan 1.x and Rails 4 strong
  # parameters protection. Basically, CanCan attempts to access the params directly when it loads
  # the resource. This work-around (see https://github.com/ryanb/cancan/issues/835#issuecomment-18663815)
  # looks for a params filtering method named after the resource and assigns the results of that method
  # to the corresponding entry in params.
  before_filter do
    if respond_to?('cancan_params_method_override', true)
      method = 'cancan_params_method_override'
    else
      resource = controller_name.singularize.to_sym
      method = "#{resource}_params"
    end
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def test_flash_messages
    if params['test_flash']
      flash[:notice] = 'This is a test flash message'
    end
  end

  def index
    redirect_to org_root_path :organization_id => current_user.organization
  end

  def disable_layout_messages
    @disable_layout_messages = true
  end

  def inject_global_layout_variables
    @analytics_enabled = Rails.application.config.vocat.tracking[:analytics_enabled]
    @analytics_id = Rails.application.config.vocat.tracking[:analytics_id]
    @analytics_domain = Rails.application.config.vocat.tracking[:analytics_domain]
  end

  def inject_aws_info
    @S3_bucket = Rails.application.config.vocat.aws[:s3_bucket]
    @aws_public_key = Rails.application.config.vocat.aws[:key]
  end

  def inject_session_data
    @session_data = {
      enable_glossary: current_user.nil? ? false : current_user.get_setting_value('enable_glossary')
    }
  end

  def after_sign_in_path_for(user)
    if user.role? 'admin'
      sign_in_url = url_for(:action => 'index', :controller => 'admin/dashboard')
    else
      sign_in_url = '/'
    end
  end

  def get_organization_and_current_course

    if params[:controller].downcase.starts_with?('course')
      course_id = params[:course_id]
      if course_id
        @selected_course = Course.find(course_id)

        if @selected_course
          authorize!(:show, @selected_course)
          session[:course_id] = @selected_course.id
        end

        if @selected_course && current_user
          @selected_course_role = @selected_course.role(current_user)
        else
          @selected_course_role = nil
        end
      end
    end

    if current_user
      @current_organization = current_user.organization
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

    def project_params
      params.require(:project).permit(:name,
                                      :description,
                                      :course_id,
                                      :rubric_id
      )
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
                                         :smpte_timecode,
                                         :published,
                                         :seconds_timecode,
                                         :video_id
      )
    end

    def attachment_params
      params.require(:attachment).permit(:media_file_name)
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
