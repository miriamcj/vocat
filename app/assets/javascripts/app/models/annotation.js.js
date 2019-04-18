define [
  'backbone'
], (Backbone) ->
  class AnnotationModel extends Backbone.Model

    urlRoot: '/api/v1/annotations'
    paramRoot: 'annotation'

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

    hasDrawing: () ->
      canvas = @get('canvas')
      if canvas?
        data = JSON.parse(canvas)
        return data.svg != null
      else
        return false

    getCanvasJSON: () ->
      json = null
      canvas = @get('canvas')
      if canvas?
        imgData = JSON.parse(canvas)
        json = imgData.json
        json

    getSvg: () ->
      svg = null
      canvas = @get('canvas')
      if canvas?
        imgData = JSON.parse(canvas)
        svg = imgData.svg
        svg

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

    activate: () ->
      if @collection
        @collection.activateModel(@)

    toJSON: () ->
      attributes = _.clone(this.attributes);
      $.each attributes, (key, value) ->
        if value? && _(value.toJSON).isFunction()
          attributes[key] = value.toJSON()
      attributes.smpte_timecode = @getTimestamp()
      attributes