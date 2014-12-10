define (require) ->

  Backbone = require('backbone')
  AnnotationCollection = require('collections/annotation_collection')

  class AssetModel extends Backbone.Model

    annotationCollection : null
    urlRoot: "/api/v1/assets"

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

    updateAnnotationCollection: () ->
      if !@annotationCollection
        @annotationCollection = new AnnotationCollection(@get('annotations'), {assetId: @id})
      else
        @annotationCollection.reset(@get('annotations'))

    annotations: () ->
      @annotationCollection
