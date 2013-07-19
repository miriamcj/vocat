define [
  'marionette', 'hbs!templates/submission/post', 'collections/discussion_post_collection', 'models/discussion_post', 'views/submission/discussion_base_view'
], (
  Marionette, template, DiscussionPostCollection, DiscussionPostModel, DiscussionBaseView
) ->

  class PostView extends DiscussionBaseView

    template: template

    itemViewContainer: '[data-behavior="post-container"]'

    triggers:
      'click [data-behavior="post-save"]': 'post:save'
      'click [data-behavior="toggle-reply"]': 'reply:toggle'
      'click [data-behavior="toggle-delete-confirm"]': 'confirm:delete:toggle'
      'click [data-behavior="delete"]': 'post:delete'

    tagName: 'li'

    initialize: (options) ->
      @allPosts = options.allPosts
      @submission = options.submission
      @vent = options.vent
      @collection = new DiscussionPostCollection([],{})
      @collection.reset(@allPosts.where({parent_id: @model.id}))

    onConfirmDeleteToggle: () ->
      @$el.find('[data-behavior="delete-confirm"]:first').slideToggle(150)

    onPostDelete: () ->
      @allPosts.remove(@model)
      @model.destroy({wait: true})

    onReplyToggle: () ->
      @ui.inputToggle.slideToggle({duration: 200})

    handleSavePost: (e) ->
      if e.keyCode == 13
        e.preventDefault()
        e.stopPropagation()
        postInput = $(e.currentTarget)
        # The actual saving of the post is handled in the discussions view.
        @vent.trigger('post:save', postInput)

    handleDestroyedPost: () ->
      @$el.fadeOut(250, () =>
        @remove()
      )

