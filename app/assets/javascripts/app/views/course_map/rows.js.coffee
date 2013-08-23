define ['marionette', 'hbs!templates/course_map/rows', 'views/course_map/row_item'], (Marionette, template, ItemView) ->

  class RowsView extends Marionette.CompositeView

    itemView: ItemView
    template: template

    ui: {
      spacer: '[data-behavior="spacer"]'
    }

    appendHtml: (collectionView, itemView, index) ->
      itemView.$el.insertBefore(collectionView.ui.spacer)

    serializeData: () ->
      {
        projectCount: @collections.project.length
      }

    itemViewOptions: () ->
      {
      vent: @vent
      collection: @collections.project
      submissions: @collections.submission
      }

    initialize: (options) ->
      @collections = options.collections
      @vent = options.vent
