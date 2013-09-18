define ['backbone'], (Backbone) ->
  class VideoModel extends Backbone.Model

    paramRoot: 'video'

    urlRoot: "/api/v1/videos"
