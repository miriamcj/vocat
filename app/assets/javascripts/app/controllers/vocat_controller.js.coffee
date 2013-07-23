define ['marionette', 'jquery_rails'], (Marionette, $) ->

  class VocatController extends Marionette.Controller

    collections: {
    }

    initialize: () ->
      @bootstrapCollections()

    isBlank: (str) ->
      if str == null then str = ''
      (/^\s*$/).test(str)

    bootstrapCollections: () ->
      _.each @collections, (collection, collectionKey) =>
        dataContainer = $("#bootstrap-#{collectionKey}")
        if dataContainer.length > 0
          div = $('<div></div>')
          div.html dataContainer.text()
          text = div.text()
          if !@isBlank(text)
            data = JSON.parse(text)
            if data[collectionKey]? then collection.reset(data[collectionKey])
