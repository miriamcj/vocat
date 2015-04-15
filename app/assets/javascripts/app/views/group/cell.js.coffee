define ['marionette', 'hbs!templates/group/cell'], (Marionette, template) ->
  class Cell extends Marionette.ItemView

    template: template

    tagName: 'td'

    ui: {
      checkbox: 'input'
      switch: '.switch'
    }

    triggers: {
      'click @ui.checkbox': {
        event: 'click:input'
        preventDefault: false
      }
    }

    onClickInput: () ->
      @vent.triggerMethod('dirty')
      if @isEnrolled() == true
        ids = _.clone(@model.get('creator_ids'))
        ids = _.without(ids, @creator.id)
        @model.set('creator_ids', ids)
      else
        ids =  _.clone(@model.get('creator_ids'))
        ids.push(@creator.id)
        @model.set('creator_ids', ids)
      @updateUiState()

    serializeData: () ->
      {
      enrolled: @isEnrolled()
      cid: @cid
      creatorId: @creator.id
      }

    isEnrolled: () ->
      res = _.indexOf(@model.get('creator_ids'), @creator.id) > -1
      res

    initialize: (options) ->
      @creator = options.creator
      @vent = options.vent

    onShow: () ->
      @listenTo(@model, 'change:creator_ids', () =>
        @updateUiState()
      )

    updateUiState: () ->
      res = @isEnrolled()
      if @isEnrolled()
        @ui.switch.addClass('switch-checked')
        @ui.checkbox.attr('checked', true)
      else
        @ui.switch.removeClass('switch-checked')
        @ui.checkbox.attr('checked', false)
