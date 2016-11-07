define (require) ->
  template = require('hbs!templates/rubric/criteria')
  ItemView = require('views/rubric/criteria_item')


  class Criteria extends Marionette.CompositeView

    template: template
    className: 'criteria'
    childViewContainer: '[data-region="criteria-rows"]'
    childView: ItemView

    childViewOptions: () ->
      {
        collection: @collection
      }

    initialize: (options) ->
