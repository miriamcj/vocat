define ['marionette', 'hbs!templates/rubric/ranges', 'views/rubric/ranges_item'], (Marionette, template, ItemView) ->

  class RangesView extends Marionette.CompositeView

    tagName: 'thead'
    template: template
    childViewContainer: "tr"
    childView: ItemView
    childViewOptions: () ->
      {
        vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent