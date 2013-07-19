define ['backbone'], (Backbone) ->

  class DiscussionPostModel extends Backbone.Model

    urlRoot: '/api/v1/discussion_posts'

    hasParent: () ->
      if @get('parent_id')?
        true
      else
        false
