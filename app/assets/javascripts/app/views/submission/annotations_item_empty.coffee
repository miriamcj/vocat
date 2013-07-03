define ['marionette', 'hbs!templates/submission/annotations_item_empty'], (Marionette, template) ->

  class AnnotationsEmptyView extends Marionette.ItemView

    template: template
    tagName: 'li'
    className: 'annotations--item'
