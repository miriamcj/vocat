define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/row_empty')

  class RowEmpty extends Marionette.ItemView

    tagName: 'tr'
    template: template