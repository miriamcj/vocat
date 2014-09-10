define [
  'marionette', 'hbs!templates/submission/discussion', 'collections/discussion_post_collection', 'views/submission/post', 'views/submission/discussion_base_view', 'models/discussion_post'
], (
  Marionette, template, DiscussionPostCollection, PostView, DiscussionBaseView, DiscussionPostModel
) ->

  class DiscussionView extends DiscussionBaseView

    template: template

    childViewContainer: '[data-behavior="post-container"]'
    childView: PostView

    initialize: (options) ->
      @initializeFlash()
      @vent = options.vent
      @submission = options.submission
      @collection = new DiscussionPostCollection([],{})
      @allPosts = new DiscussionPostCollection([],{})
      @allPosts.fetch({
          data: {submission: @submission.id}
          success: () =>
            @collection.reset(@allPosts.where({parent_id: null}))
        })

      @updateCount()

      @listenTo(@allPosts,'add sync remove', (post) =>
        @updateCount()
      )

    onShow: () ->
      #@$el.find('textarea').autosize()

    updateCount: () ->
      @$el.find('[data-behavior="post-count"]').html(@allPosts.length)
