class Vocat.Models.DiscussionPost extends Backbone.Model

  url: () ->
    url = '/api/v1/'
    url = url + "submissions/#{@get('submission_id')}/"
    url + 'discussion_posts'

  hasParent: () ->
    if @get('parent_id')?
      true
    else
      false

  getUrl: (method) ->
    out = ''
    switch method.toLowerCase()
      when 'read'
        out = "/api/v1/discussion_posts/#{encodeURIComponent(@id)}"
      when 'create'
        out = "/api/v1/submissions/#{@get('submission_id')}/discussion_posts"
      when 'update'
        out = "/api/v1/discussion_posts/#{encodeURIComponent(@id)}"
      when 'delete'
        out = "/api/v1/discussion_posts/#{encodeURIComponent(@id)}"
    out

  sync: (method, model, options) ->
    options = options || {}

    options.url = model.getUrl(method)
    Backbone.sync(method, model, options)
