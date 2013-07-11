define ['marionette', 'hbs!templates/submission/annotations_item'], (Marionette, template) ->

  class AnnotationItem extends Marionette.ItemView

    visible: true
    template: template
    tagName: 'li'
    className: 'annotations--item'

    triggers:
      'click [data-behavior="destroy"]': 'destroy'
      'click [data-behavior="seek"]': 'seek'

    initialize: (options) ->
      @vent = options.vent
      @errorVent = options.errorVent

      @listenTo(@vent, 'player:time', (data) =>
        if @model.get('seconds_timecode') <= data.seconds
          if @visible == false
            @visible = true
            @$el.fadeIn()
            @vent.triggerMethod('item:shown')
        else
          if @visible == true
            @visible = false
            @$el.fadeOut()
            @vent.triggerMethod('item:hidden')
      )

    onBeforeRender: () ->
      @$el.hide()
      @visible = false

    onSeek: () ->
      @vent.triggerMethod('player:seek', {seconds: @model.get('seconds_timecode')})

    onDestroy: () ->
      @model.destroy({
        success: () =>
          @errorVent.trigger('error:clear')
          @errorVent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'annotation successfully deleted'})
      , error: () =>
          @errorVent.trigger('error:clear')
          @errorVent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })