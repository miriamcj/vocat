class Vocat.Views.EvaluationDetailPost extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/post"]
  inputPartial:  HBT["backbone/templates/evaluation_detail/partials/post_input"]

  events:
    'keypress :input': 'handleSavePost'

  tagName: 'li'
#  className: 'discussion-list--item'

  initialize: (options) ->
    @discussions = options.discussions
    @model.bind('destroy', () => @handleDestroyedPost())
    @model.bind('showReply', () => @handleShowReply())

  handleSavePost: (e) ->
    if e.keyCode == 13
      postInput = $(e.currentTarget)
      # The actual saving of the post is handled in the discussions view.
      Vocat.Dispatcher.trigger('savePost', postInput)

  handleShowReply: () ->
    @$el.find('[data-behavior="input-container"]').fadeIn()

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
