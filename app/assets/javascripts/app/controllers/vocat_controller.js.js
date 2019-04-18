define (require) ->
  Marionette = require('marionette')
  LoadingView = require('views/layout/loading')
  ModalErrorView = require('views/modal/modal_error')
  $ = require('jquery_rails')

  class VocatController extends Marionette.Controller

    collections: {
    }

    initialize: () ->
      @bootstrapCollections()

    isBlank: (str) ->
      if str == null then str = ''
      (/^\s*$/).test(str)

    deferredCollectionFetching: (collection, data, msg = "loading...") ->
      deferred = $.Deferred()
      window.Vocat.main.show(new LoadingView(msg: msg))
      collection.fetch({
        reset: true
        data: data
        error: () =>
          Vocat.vent.trigger('modal:open', new ModalErrorView({
            model: @model,
            vent: @,
            message: 'Exception: Unable to fetch collection models. Please report this error to your VOCAT administrator.',
          }))
        success: () =>
          deferred.resolve()
      })
      deferred

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
