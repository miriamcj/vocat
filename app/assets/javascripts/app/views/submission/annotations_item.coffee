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

#    onRender: () ->
#      @$el.fadeIn()

    onSeek: () ->
      @vent.triggerMethod('player:seek', {seconds: @model.get('seconds_timecode')})

    onDestroy: () ->
      @model.destroy()

  #  events:
  #    'click [data-behavior="player-seek"]': 'doPlayerSeek'
  #
  #  initialize: (options) ->
  #    @model.bind('change:visibility',@updateVisibility, @)
  #
  #  doPlayerSeek: (e) ->
  #    e.preventDefault()
  #    Vocat.Dispatcher.trigger('player:seek', {seconds: @model.get('seconds_timecode')})
  #
  #  updateVisibility: () ->
  #    if @model.visible == true
  #      @$el.fadeIn()
  #    else
  #      @$el.hide()
  #
  #  render: () ->
  #    context = {
  #      author_name: @model.get('author_name')
  #      smpte_timecode: @model.get('smpte_timecode')
  #      body: @model.get('body')
  #      visibility: @model.visible
  #    }
  #    @$el.attr('data-seconds', @model.get('seconds_timecode'))
  #    @$el.html(@template(context))
  #    if @model.visible == false then @$el.hide()
  #
  #    # Return thyself!
  #    @