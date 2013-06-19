define ['marionette', 'jquery'], (Marionette, $) ->

  class VocatController extends Marionette.Controller

    collections: {
    }

    initialize: () ->
      @bootstrapCollections()

    bootstrapCollections: () ->
      _.each @collections, (collection, collectionKey) ->
        dataContainer = $("#bootstrap-#{collectionKey}")
        if dataContainer.length > 0
          div = $('<div></div>')
          div.html dataContainer.text()
          data = JSON.parse(div.text())
          if data[collectionKey]? then collection.reset(data[collectionKey])
