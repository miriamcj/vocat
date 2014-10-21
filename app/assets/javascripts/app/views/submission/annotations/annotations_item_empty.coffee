define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/annotations/annotations_item_empty')

  class AnnotationsEmptyView extends Marionette.ItemView

    template: template
    tagName: 'li'
    className: 'annotations--item'
