define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/discussion/discussion')
  DiscussionPostCollection = require('collections/discussion_post_collection')
  PostView = require('views/discussion/post')
  AbstractDiscussionView = require('views/abstract/abstract_discussion')
  DiscussionPostModel = require('models/discussion_post')

  class DiscussionView extends AbstractDiscussionView

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
      l = @allPosts.length
      if l == 1
        s = "One Comment"
      else
        s = "#{l} Comments"
      @$el.find('[data-behavior="post-count"]').html(s)
