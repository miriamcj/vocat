class Api::V1::VisitsController < ApiController

  respond_to :json
  load_resource :visit

  api :POST, "/visits", "creates a visit", :deprecated => true
  param :visitable_type, String, :desc => "The type of page visited", :required => true
  param :visitable_id, Fixnum, :desc => "The id of model visited", :required => true
  param :visitable_course_id, Fixnum, :desc => "The id of course visited", :required => true
  def create
    latest_visit = Visit.find_or_initialize_by(user_id: current_user.id, visitable_type: @visit.visitable_type, visitable_id: @visit.visitable_id, visitable_course_id: @visit.visitable_course_id)
    latest_visit.new_record? ? latest_visit.save : latest_visit.touch
    respond_with latest_visit, :root => false, status: :created, location: api_v1_submission_url(latest_visit)
  end
end
