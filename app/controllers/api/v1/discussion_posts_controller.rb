class Api::V1::DiscussionPostsController < ApiController

  # TODO: Authorize the resources correctly
  #load_and_authorize_resource :submission
  load_and_authorize_resource :discussion_post
  respond_to :json

  # GET /api/v1/submissions/1/discussion_posts.json
  def index
    @submission = Submission.find(params[:submission_id])
    # TODO: Authorize Submission
    @discussion_posts = DiscussionPost.find_all_by_submission_id(@submission.id)
    respond_with @discussion_posts
  end

  def destroy
    @discussion_post.destroy
    respond_with(@discussion_post)
  end

  def create
    @discussion_post.author_id = current_user.id
    if @discussion_post.save
      respond_with @discussion_post, :root => false, status: :created, location: ''
      #, location: api_v1_submission_discussion_post_url(@submission.id, @discussion_post.id)
    else
      respond_with @discussion_post.errors, :root => false, status: :unprocessable_entity
    end
  end

end
