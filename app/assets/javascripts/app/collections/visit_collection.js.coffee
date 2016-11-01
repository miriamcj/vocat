define ['backbone', 'marionette', 'models/visit'], (Backbone, Marionette, VisitModel) ->

  class VisitCollection extends Backbone.Collection

    model: VisitModel

    initialize: (models, options) ->
      @options = options
