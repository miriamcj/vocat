define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_list')
  EnrollmentItem = require('views/admin/enrollment_item')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class CreatorEnrollment extends Marionette.CompositeView

    template: template

    itemViewContainer: "tbody",

    itemView: EnrollmentItem

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
      @collection.fetch()
