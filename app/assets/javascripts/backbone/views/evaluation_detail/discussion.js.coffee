class Vocat.Views.EvaluationDetailDiscussion extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/discussion"]
  inputPartial:  HBT["backbone/templates/evaluation_detail/partials/post_input"]

  events:
    'keypress [data-behavior="parent-input"] textarea': 'handleSavePost'
    'click [data-behavior="delete"]': 'deletePost'
    'click [data-behavior="reply"]': 'replyToPost'

  initialize: (options) ->
    @submission = options.submission
    @discussions = new Vocat.Collections.DiscussionPost([],{submissionId: @submission.id})
    @discussions.fetch(
      success: =>
        @render()
    )
    @discussions.bind('add', (post) =>
      @addPost(post)
    )
    Vocat.Dispatcher.bind('savePost', (postInput) =>
      @savePost(postInput)
    )

  addPost: (post) ->
    target = @getPostTarget(post)
    postView = new Vocat.Views.EvaluationDetailPost({discussions: @discussions, model: post})
    target.append(postView.render().el)

  getPostTarget: (post) ->
    if post.get('parent_id')
      target = @$el.find('[data-post="' + post.get('parent_id') + '"] [data-behavior="post-container"]')
    else
      target = @$el.find('[data-behavior="post-container"]:first')

  replyToPost: (e) ->
    e.preventDefault()
    postId = $(e.currentTarget).data().post
    post = @discussions.get(postId)
    post.trigger('showReply')

  deletePost: (e) ->
    e.preventDefault()
    postId = $(e.currentTarget).data().post
    results = @discussions.get(postId).destroy({wait: true})

  # Handling the post is broken out from the actual saving because child posts also contain
  # a new post interface, and we want to route all new post submissions through a single save
  # post method.
  handleSavePost: (e) ->
    if e.keyCode == 13
      postInput = $(e.currentTarget)
      Vocat.Dispatcher.trigger('savePost', postInput)

  savePost: (postInput) ->
      data = postInput.data()
      console.log data, 'data'

      if data.parent?
        parentId = data.parent
      else
        parentId = null

      post = new Vocat.Models.DiscussionPost({
        submission_id: @submission.id
        project_id: @submission.get('project_id')
        creator_id: @submission.get('creator_id')
        body: postInput.val()
        published: true
        parent_id: parentId
      })

      postInput.val('').trigger('autosize');

      post.save({},{
        success: (post) =>
          @discussions.add(post)
      })

  render: () ->
    context = {
      postCount: @discussions.length
      post_input: @inputPartial({})
    }

    @$el.html(@template(context))
    @$el.find('textarea').autosize()

    @discussions.each( (post) =>
      postTarget = @getPostTarget(post)
      @addPost(post)
    )


    # Return thyself for maximum chaining!
    @
