class Vocat.Models.DiscussionPost extends Backbone.Model

  url: () ->
    url = '/api/v1/'
    url = url + "submissions/#{@get('submission_id')}/"
    url + 'discussion_posts'

