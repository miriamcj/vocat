define (require) ->

  Marionette = require('marionette')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class EnrollmentUserList extends Marionette.CompositeView

    itemViewContainer: "tbody",

    itemViewOptions: () ->
      {
        vent: @vent
      }

    ui: {
      studentInput: '[data-behavior="student-input"]'
    }

    appendHtml: (collectionView, itemView, index) ->
      if collectionView.itemViewContainer
        childrenContainer = collectionView.$(collectionView.itemViewContainer)
      else
        childrenContainer = collectionView.$el

      children = childrenContainer.children()
      if children.size() <= index
        childrenContainer.append(itemView.el)
      else
        children.eq(index).before(itemView.el)

    initialize: (options) ->
      @vent = options.vent
      @template = options.template
      @collection.fetch()
