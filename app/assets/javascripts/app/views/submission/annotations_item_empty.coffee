define ['marionette', 'hbs!templates/submission/annotations_item_empty'], (Marionette, template) ->

  class AnnotationsEmptyView extends Marionette.ItemView

    template: template
    tagName: 'li'
    className: 'annotations--item'

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