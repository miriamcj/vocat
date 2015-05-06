class Api::V1::DiscussionPostsController < ApiController

  load_and_authorize_resource :discussion_post
  respond_to :json

  def_param_group :discussion_post do
    param :submission_id, Fixnum, :desc => "The ID of the submission being discussed", :required => true, :action_aware => true
    param :parent_id, Fixnum, :desc => "If the post is a reply to another post, this is the ID of the parent post."
    param :body, Fixnum, :desc => "The body of the post, can be Markdown which will be converted to HTML when the post is rendered", :required => true, :action_aware => true
  end

  resource_description do
    description <<-EOS
      Discussion Posts appear on submission detail views. A post can be threaded, and can have another discussion posts as
      its parent. As with annotations, the author_id value of a discussion post is set to the user who creates the post.
      The API does not currently provide a mechanism for creating discussion posts that belong to other users.
    EOS
  end

  api :GET, '/discussion_posts?submission=:submission', "returns all discussion posts for a given submission"
  description "<em>Nota Bene</em>: the posts are returned in a flat array. It is the responsibility of the client application to structure the posts into a parent/child hierarchy based on the parent_id."
  param :submission, Fixnum, :desc => "The ID of the submission to query for discussion posts"
  example <<-EOF
    Sample Response:

    [
       {
          "id":1816,
          "author_id":4470,
          "author_name":"Ressie Crona",
          "body":"\u003cp\u003eThis is the body of the post. \u003cem\u003eMarkdown\u003c/em\u003e is \u003cem\u003esupported\u003c/em\u003e\u003c/p\u003e",
          "body_raw":"This is the body of the post. _Markdown_ is *supported*",
          "published":null,
          "parent_id":null,
          "gravatar":"http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm\u0026s=",
          "created_at":"2015-05-06T13:44:21.755-04:00",
          "month":"May",
          "day":"06",
          "year":"2015",
          "time":"01:44 PM",
          "current_user_can_reply":true,
          "current_user_can_destroy":true,
          "submission_id":7394
       },
       {
          "id":1817,
          "author_id":4470,
          "author_name":"Ressie Crona",
          "body":"\u003cp\u003eThis is the body of the post. \u003cem\u003eMarkdown\u003c/em\u003e is \u003cem\u003esupported\u003c/em\u003e\u003c/p\u003e",
          "body_raw":"This is the body of the post. _Markdown_ is *supported*",
          "published":null,
          "parent_id":null,
          "gravatar":"http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm\u0026s=",
          "created_at":"2015-05-06T13:46:23.515-04:00",
          "month":"May",
          "day":"06",
          "year":"2015",
          "time":"01:46 PM",
          "current_user_can_reply":true,
          "current_user_can_destroy":true,
          "submission_id":7394
       },
       {
          "id":1818,
          "author_id":4470,
          "author_name":"Ressie Crona",
          "body":"\u003cp\u003eThis is the body of the post. \u003cem\u003eMarkdown\u003c/em\u003e is \u003cem\u003esupported\u003c/em\u003e\u003c/p\u003e",
          "body_raw":"This is the body of the post. _Markdown_ is *supported*",
          "published":null,
          "parent_id":null,
          "gravatar":"http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm\u0026s=",
          "created_at":"2015-05-06T13:47:05.047-04:00",
          "month":"May",
          "day":"06",
          "year":"2015",
          "time":"01:47 PM",
          "current_user_can_reply":true,
          "current_user_can_destroy":true,
          "submission_id":7394
       }
    ]
  EOF
  def index
    @submission = Submission.find(params.require(:submission))
    authorize! :show, @submission
    @discussion_posts = DiscussionPost.where(submission: @submission)
    respond_with @discussion_posts
  end


  api :POST, '/discussion_posts', "creates a discussion post for a submission"
  param_group :discussion_post
  example <<-EOF
    Sample Request:

    {
        "submission_id": "7394",
        "body": "This is the body of the post. _Markdown_ is *supported*",
        "parent_id": null
    }
  EOF
  example <<-EOF
    Sample Response:

    {
        "id": 1817,
        "author_id": 4470,
        "author_name": "Ressie Crona",
        "body": "<p>This is the body of the post. <em>Markdown</em> is <em>supported</em></p>",
        "body_raw": "This is the body of the post. _Markdown_ is *supported*",
        "published": null,
        "parent_id": null,
        "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
        "created_at": "2015-05-06T13:46:23.515-04:00",
        "month": "May",
        "day": "06",
        "year": "2015",
        "time": "01:46 PM",
        "current_user_can_reply": true,
        "current_user_can_destroy": true,
        "submission_id": 7394
    }
  EOF
  def create
    @discussion_post.author_id = current_user.id
    if @discussion_post.save
      respond_with @discussion_post, status: :created, location: api_v1_discussion_post_url(@discussion_post.id)
    else
      respond_with @discussion_post, status: :unprocessable_entity
    end
  end



  api :PATCH, '/discussion_posts/:id', "creates a discussion post for a submission"
  param :id, Fixnum, :desc => "The ID of the discussion post to be updated"
  param_group :discussion_post
  example <<-EOF
    Sample Request:

    {
        "id": "1816",
        "body": "This is the UPDATED body of the post. _Markdown_ is *supported*"
    }
  EOF
  def update
    @discussion_post.update_attributes(discussion_post_params)
    respond_with @discussion_post, status: :updated, location: api_v1_discussion_post_url(@discussion_post.id)
  end



  api :DELETE, '/discussion_posts/:id', "deletes a single discussion post"
  param :id, Fixnum, :desc => "The ID of the discussion post to be deleted"
  def destroy
    @discussion_post.destroy
    respond_with(@discussion_post)
  end


end
