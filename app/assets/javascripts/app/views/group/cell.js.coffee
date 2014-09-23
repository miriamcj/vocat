define ['marionette', 'hbs!templates/group/cell'], (Marionette, template) ->

  class Cell extends Marionette.ItemView

    template: template

    tagName: 'td'

    triggers: {
      'click input': 'click:input'
    }

    onClickInput: () ->
      @vent.triggerMethod('dirty')

      if @isEnrolled() == true
        @model.set('creator_ids', _.without(@model.get('creator_ids'), @creator.id))
      else
        @model.get('creator_ids').push(@creator.id)
      @render()

    serializeData: () ->
      {
        enrolled: @isEnrolled()
        cid: @cid
      }

    isEnrolled: () ->
      _.indexOf(@model.get('creator_ids'), @creator.id) > -1

    initialize: (options) ->
      @creator = options.creator
      @vent = options.vent

      @listenTo(@model,'change:creator_ids', @render)
