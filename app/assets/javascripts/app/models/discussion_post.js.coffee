define ['backbone'], (Backbone) ->
  class DiscussionPostModel extends Backbone.Model

    urlRoot: '/api/v1/discussion_posts'

    hasParent: () ->
      if @get('parent_id')?
        true
      else
        false

    validate: (attrs, options) ->
      errors = {}

      if !attrs.body || attrs.body.length < 1
        unless errors.body && _.isArray(errors.body) then errors.body = []
        errors.body.push('cannot be empty.')

      unless attrs.submission_id?
        unless errors.body && _.isArray(errors.body) then errors.body = []
        errors.push({name: 'submission_id', message: 'All posts must be associated with a submission.'})

      if _.size(errors) > 0 then errors else false
