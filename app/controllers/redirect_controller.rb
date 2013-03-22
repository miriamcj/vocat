class RedirectController < ApplicationController

  def index()
    creator_url   = params[:creator_url]
    evaluator_url = params[:evaluator_url]

    if @current_user.role? :evaluator
      url = evaluator_url
    else
      url = creator_url
    end

    url = url.gsub(":organization_id", params[:organization_id]) if params.has_key? :organization_id
    url = url.gsub(":course_id", params[:course_id]) if params.has_key? :course_id
    redirect_to url
  end

end