class Api::V1::DiscussionPostsController < ApiController

  # TODO: Authorize the resources correctly
  load_and_authorize_resource :submission
  load_resource :discussion_post
  respond_to :json

  # GET /api/v1/submissions/1/discussion_posts.json
  def index
    @discussion_posts = DiscussionPost.for_submission(@submission)
    respond_with @discussion_posts
  end

  def create
    @discussion_post.author_id = current_user.id
    if @discussion_post.save
      respond_with @discussion_post, :root => false, status: :created, location: api_v1_submission_discussion_post_url(@submission.id, @discussion_post.id)
    else
      respond_with @discussion_post.errors, :root => false, status: :unprocessable_entity
    end
  end

end
