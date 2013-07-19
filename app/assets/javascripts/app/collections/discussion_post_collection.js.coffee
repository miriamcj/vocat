define ['backbone', 'models/discussion_post'], (Backbone, DiscussionPostModel) ->
  class DiscussionPostCollection  extends Backbone.Collection

    model: DiscussionPostModel

    initialize: (models, options) ->
      if options.submissionId? then @submissionId = options.submissionId
      @bind('remove', (model) =>
        if model.id?
          children = @where('parent_id': model.id)
          _.each(children, (child) =>
            # We trigger a destroy event so that the model is removed from the collection and the view is removed from
            # memory. We don't do an actual destroy REST requset, because the children are deleted server-side when the
            # parent is deleted.
            child.trigger('destroy', child, child.collection, {});
          )
      )

    url: '/api/v1/discussion_posts'

    getParentPosts: () ->
      @where({'parent_id': null})

    getChildPosts: () ->
      @filter (post) ->
        post.get('parent_id') != null