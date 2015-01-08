define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations_item_empty')

  class AnnotationsEmptyView extends Marionette.ItemView

    template: template
    tagName: 'li'
    className: 'annotation'
