define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/ranges')
  ItemView = require('views/rubric/ranges_item')
  EmptyView = require('views/rubric/ranges_empty')

  class RangesView extends Marionette.CompositeView

    tagName: 'thead'
    template: template
    childViewContainer: "tr"
    childView: ItemView
    emptyView: EmptyView
    childViewOptions: () ->
      {
        collection: @collection
        vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent