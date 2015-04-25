class CustomSignInFailure < Devise::FailureApp

  def redirect_url
    send(:"new_#{scope}_session_path")
  end

  # You need to override respond to eliminate recall
  def respond
    Rails.logger.info "########## CUSTOM FAILURE APP CALLED"
    if !attempted_path.start_with?('/oauth')
      redirect
    else
      self.status = 401
      self.content_type = request.format.to_s
      self.response_body = '{"errors": ["Vocat wasn\'t able to find an account with this username and password. Please re-enter and try again."]}'
    end
  end
end