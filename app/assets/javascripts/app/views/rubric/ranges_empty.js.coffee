define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/ranges_empty')

  class RangesEmptyView extends Marionette.ItemView

    template: template
    tagName: 'th'
    attributes: {
      'data-match-height-source': ''
    }

    initialize: (options) ->


