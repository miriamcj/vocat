define [
  'marionette', 'hbs!templates/submission/post', 'collections/discussion_post_collection', 'models/discussion_post', 'views/submission/discussion_base_view'
], (
  Marionette, template, DiscussionPostCollection, DiscussionPostModel, DiscussionBaseView
) ->

  class PostView extends DiscussionBaseView

    template: template

    childViewContainer: '[data-behavior="post-container"]'

    tagName: 'li'

    initialize: (options) ->
      @initializeFlash()
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

