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
            url: "http://www.youtube.com/watch?v=#{@get('source_id')}"
          }
        when 'vimeo'
          {
            mime: 'video/vimeo'
            key: 'vimeo'
            url: "http://vimeo.com/#{@get('source_id')}"
          }
        when 'attachment'
          {
            mime: 'video/mp4'
            key: 'html5'
            url: @get('attachment_url')
          }
