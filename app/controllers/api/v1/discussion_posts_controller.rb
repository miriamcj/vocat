class Api::V1::DiscussionPostsController < ApiController

  load_and_authorize_resource :discussion_post
  respond_to :json

  # GET /api/v1/discussion_posts.json?submission=:submission
  def index
    @submission = Submission.find(params.require(:submission))
    authorize! :show, @submission
    @discussion_posts = DiscussionPost.where(submission: @submission)
    respond_with @discussion_posts
  end

  # DELETE /api/v1/discussion_posts/:id.json
  def destroy
    @discussion_post.destroy
    respond_with(@discussion_post)
  end

  # PATCH /api/v1/discussion_posts/:id.json
  def update
    @discussion_post.update_attributes(discussion_post_params)
  end

  # POST /api/v1/discussion_posts.json
  def create
    @discussion_post.author_id = current_user.id
    if @discussion_post.save
      respond_with @discussion_post, status: :created, location: api_v1_discussion_post_url(@discussion_post.id)
    else
      respond_with @discussion_post, status: :unprocessable_entity
    end
  end

end
