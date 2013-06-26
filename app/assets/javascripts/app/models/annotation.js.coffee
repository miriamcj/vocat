define [
  'backbone'
], (
  Backbone
) ->
  class AnnotationModel extends Backbone.Model

    urlRoot: '/api/v1/annotations'
    paramRoot: 'annotation'

    urlRoot: () ->
      url = '/api/v1/'
      if @get('attachment_id')
        url = url + "attachment/#{@get('attachment_id')}/"
        url + 'annotations'

    initialize: () ->
      @visible = false
      @locked = false

    setVisibility: (visibility) ->
      if @locked == false
        @visible = visibility
        @trigger('change:visibility')

    lockVisible: () ->
      @locked = false
      @show()
      @locked = true

    unlock: () ->
      @locked = false

    show: () ->
      if @visible == false then @setVisibility(true)

    hide: () ->
      if @visible == true then @setVisibility(false)

    getTimestamp: () ->
      totalSeconds = parseInt(@get('seconds_timecode'))
      totalMinutes = Math.floor(totalSeconds / 60)
      hours = Math.floor(totalMinutes / 60)
      minutes = totalMinutes - (hours * 60)
      seconds = totalSeconds - (hours * 60 * 60) - (minutes * 60)
      fh = ("0" + hours).slice(-2);
      fm = ("0" + minutes).slice(-2);
      fs = ("0" + seconds).slice(-2);
      "#{fh}:#{fm}:#{fs}"

    toJSON: () ->
      attributes = _.clone(this.attributes);
      $.each attributes, (key, value) ->
        if value? && _(value.toJSON).isFunction()
          attributes[key] = value.toJSON()
      attributes.smpte_timecode = @getTimestamp()
      attributes