define ['marionette', 'hbs!templates/rubric/cell', 'views/rubric/cell_edit'], (Marionette, template, CellEditView) ->

  class Cell extends Marionette.ItemView

    template: template

    tagName: 'li'
    className: 'matrix--cell'

    onShow: () ->
      @$el.on( 'click', (event) =>
        @triggerMethod('open:modal')
      )

    initialize: (options) ->
      @vent = Vocat.vent
      @listenTo(@model,'change', () =>
        @render()
      )

    onOpenModal: () ->
      @vent.trigger('modal:open', new CellEditView({model: @model, vent: @vent}))