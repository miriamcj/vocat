define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/fields_empty')

  class RangesEmptyView extends Marionette.ItemView

    template: template
    tagName: 'tr'

    initialize: (options) ->


