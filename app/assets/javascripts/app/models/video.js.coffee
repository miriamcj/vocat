define ['backbone'], (Backbone) ->
  class VideoModel extends Backbone.Model

    paramRoot: 'video'

    urlRoot: "/api/v1/videos"

    getSourceDetails: () ->
      switch @get('source')
        when 'youtube'
          {
            mime: 'video/youtube'
            key: 'youtube'
          }
        when 'vimeo'
          {
            mime: 'video/vimeo'
            key: 'vimeo'
          }
        when 'attachment'
          {
            mime: 'video/mp4'
            key: 'html5'
          }
