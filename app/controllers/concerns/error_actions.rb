
module ErrorActions
  extend ActiveSupport::Concern

  included do
    if Rails.env.production?
      rescue_from Exception, with: :forbidden
      rescue_from CanCan::AccessDenied, with: :access_denied
      rescue_from ActionController::RoutingError, with: :not_found
      rescue_from ActionController::UnknownController, with: :not_found
      rescue_from ActionController::UnknownFormat, with: :not_found
      rescue_from ActionController::UnknownHttpMethod, with: :not_found
    end
  end

  def not_found
    @type = 'Page not found'
    @message = 'VOCAT has experienced a 404 error.'
    respond_to do |format|
      format.html { render 'application/error', :layout => 'application' }
      format.all { render nothing: true, status: 404}
    end
  end

  def access_denied
    @type = 'Access Denied'
    @message = 'You do not have access to the requested resource.'
    respond_to do |format|
      format.html { render 'application/error', :layout => 'application' }
      format.all { render nothing: true, status: 403}
    end
  end

  def forbidden
    @type = '500: Internal Application Error'
    @message = 'VOCAT has experienced a 500 error.'
    respond_to do |format|
      format.html { render 'application/error', :layout => 'application' }
      format.all { render nothing: true, status: 500}
    end
  end

end

