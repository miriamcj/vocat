class Vocat.Views.EvaluationDetailPost extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/post"]
  inputPartial:  HBT["backbone/templates/evaluation_detail/partials/post_input"]

  events:
    'keypress :input': 'handleSavePost'
    'click [data-behavior="toggle-reply"]': 'handleToggleReply'
    'click [data-behavior="toggle-delete-confirm"]': 'toggleDeleteConfirm'
    'click [data-behavior="delete"]': 'deletePost'


  tagName: 'li'
#  className: 'discussion-list--item'

  initialize: (options) ->
    @discussions = options.discussions
    @model.bind('destroy', () => @handleDestroyedPost())
    @model.bind('toggleReply', () => @toggleReply())

  toggleDeleteConfirm: (e) ->
    e.stopPropagation()
    e.preventDefault()
    console.log @el
    @$el.find('[data-behavior="delete-confirm"]:first').slideToggle(150)

  deletePost: (e) ->
    e.stopPropagation()
    e.preventDefault()
    postId = $(e.currentTarget).data().post
    results = @discussions.get(postId).destroy({wait: true})

  toggleReply: (e) ->
    @$el.find('[data-behavior="input-container"]').slideToggle()

  handleSavePost: (e) ->
    if e.keyCode == 13
      e.preventDefault()
      e.stopPropagation()
      postInput = $(e.currentTarget)
      # The actual saving of the post is handled in the discussions view.
      Vocat.Dispatcher.trigger('savePost', postInput)

  handleToggleReply: (e) ->
    e.stopPropagation()
    e.preventDefault()
    postId = $(e.currentTarget).data().post
    post = @discussions.get(postId)
    post.trigger('toggleReply')

  handleDestroyedPost: () ->
    @$el.fadeOut(250, () =>
      @remove()
    )

  render: () ->
    context = {
      post_input: @inputPartial({parent: @model.get('id')})
      post: @model.toJSON()
    }
    @$el.html(@template(context))
    @$el.attr('data-post', @model.id)
    # Return thyself for maximum chaining!
    @
