define [
  'marionette', 'hbs!templates/submission/discussion', 'collections/discussion_post_collection', 'views/submission/post', 'views/submission/discussion_base_view', 'models/discussion_post'
], (
  Marionette, template, DiscussionPostCollection, PostView, DiscussionBaseView, DiscussionPostModel
) ->

  class DiscussionView extends DiscussionBaseView

#    template: HBT["app/templates/evaluation_detail/discussion"]
#    inputPartial:  HBT["app/templates/evaluation_detail/partials/post_input"]

    template: template

    triggers:
      'click [data-behavior="post-save"]': 'post:save'

    itemViewContainer: '[data-behavior="post-container"]'
    itemView: PostView


    initialize: (options) ->
      @submission = options.submission
      @collection = new DiscussionPostCollection([],{})
      @allPosts = new DiscussionPostCollection([],{})
      @allPosts.fetch({
          data: {submission_id: @submission.id}
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
