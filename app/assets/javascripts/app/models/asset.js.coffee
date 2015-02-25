define (require) ->

  Backbone = require('backbone')
  AnnotationCollection = require('collections/annotation_collection')

  class AssetModel extends Backbone.Model

    annotationCollection : null
    urlRoot: "/api/v1/assets"
    polls: 0

    techOrder: () ->
      switch @get('type')
        when 'Asset::Youtube'
          ['youtube']
        when 'Asset::Vimeo'
          ['vimeo']
        else
          ['html5']

    initialize: () ->
      @listenTo(@, 'sync change:annotations', () =>
        @updateAnnotationCollection()
      )
      @updateAnnotationCollection()

    poll: () ->
      if @get('attachment_state') == 'processing'
        wait = Math.pow(2, Math.floor(@polls/5)) * 10000
        @polls++
        @fetch({success: (model, response, options) =>
          if model.get('attachment_state') == 'processing'
            setTimeout(() =>
              @poll()
            , wait)
        })

    hasDuration: () ->
      family = @get('family')
      switch family
        when 'video' then true
        when 'image' then false
        when 'audio' then true
        else  false

    allowsVisibleAnnotation: () ->
      return false if @get('type') == 'Asset::Vimeo'
      family = @get('family')
      switch family
        when 'video' then true
        when 'image' then true
        when 'audio' then false
        else  false

    updateAnnotationCollection: () ->
      if !@annotationCollection
        @annotationCollection = new AnnotationCollection(@get('annotations'), {assetId: @id, assetHasDuration: @hasDuration()})
      else
        @annotationCollection.reset(@get('annotations'))
        @annotationCollection.assetHasDuration = @hasDuration()

    annotations: () ->
      @annotationCollection
