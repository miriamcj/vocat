class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'frames'

  check_authorization :unless => :devise_controller?
  load_resource :course

  before_filter :authenticate_user!
  before_filter :inject_session_data
  before_filter { |controller| controller.get_organization_and_current_course 'course_id' }

  # This is a bit of a hack to deal with incompatibilities between CanCan 1.x and Rails 4 strong
  # parameters protection. Basically, CanCan attempts to access the params directly when it loads
  # the resource. This work-around (see https://github.com/ryanb/cancan/issues/835#issuecomment-18663815)
  # looks for a params filtering method named after the resource and assigns the results of that method
  # to the corresponding entry in params.
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def index
    redirect_to org_root_path :organization_id => current_user.organization
  end

  def disable_layout_messages
    @disable_layout_messages = true
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

  def get_organization_and_current_course(param_name)
    if @course
      session[:course_id] = @course.id
    end

    if current_user
      @organization = current_user.organization
    end

    if @course && current_user
      @course_role = @course.role(current_user)
    else
      @course_rol = nil
    end
  end

  protected

    # Parameters for creating and updating a project
    def project_params
      params.require(:project).permit(:name, :description, :rubric_id)
    end

    def course_settings_params
      params.require(:settings).permit(*Course::ALLOWED_SETTINGS)
    end

    def course_params
      params.require(:course).permit(:id, :name, :groups_attributes => [ :id, :name, :creator_ids => [] ])
    end

    def group_params
      params.require(:group).permit(:name, :course_id, :creator_ids => [])
    end

    def annotation_params
      params.require(:annotation).permit(:body, :smpte_timecode, :published, :seconds_timecode, :video_id)
    end

    def video_params
      params.require(:video).permit(:submission_id, :name, :source, attachment_attributes: :media)
    end

    def discussion_post_params
      params.require(:discussion_post).permit(:published, :parent_id, :submission_id, :body)
    end

    def evaluation_params
      params.require(:evaluation).permit(:submission_id, :published).tap do |whitelisted|
        whitelisted[:scores] = params[:evaluation][:scores]
      end
    end

    def rubric_params
      params.require(:rubric).permit(:name, :description, :cells, :fields, :ranges, :high, :low).tap do |whitelisted|
        whitelisted[:ranges] = params[:rubric][:ranges]
        whitelisted[:fields] = params[:rubric][:fields]
        whitelisted[:cells] = params[:rubric][:cells]
      end
    end

    def submission_params
      params.require(:submission).permit(:name, video_attributes: [ :source, :source_id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :course_id, :rubric_id)
    end

end
