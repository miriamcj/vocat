class Vocat.Collections.DiscussionPost extends Backbone.Collection
  model: Vocat.Models.DiscussionPost

  initialize: (models, options) ->
    if options.submissionId? then @submissionId = options.submissionId

  url: () ->
    url = '/api/v1/'

    if @submissionId
      url = url + "submissions/#{@submissionId}/"

    url + 'discussion_posts'

  getParentPosts: () ->
    console.log @
    @where({'parent_id': null})