class CustomSignInFailure < Devise::FailureApp

  def redirect_url
    send(:"new_#{scope}_session_path")
  end

  # You need to override respond to eliminate recall
  def respond
    Rails.logger.info "########## CUSTOM FAILURE APP CALLED"
    if !attempted_path.start_with?('/oauth')
      redirect
    end
  end
end