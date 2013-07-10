define [
  'marionette', 'hbs!templates/submission/annotator', 'models/annotation'
], (
  Marionette, template, AnnotationModel
) ->
  class AnnotatorView extends Marionette.ItemView

    template: template

    ui:
      input: '[data-behavior="annotation-input"]'

    events:
      'keypress :input': 'onEventKeypress'

    triggers:
      'submit': 'submit'

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

    onEventKeypress: (e) ->
      @vent.triggerMethod('player:stop', {})

    onSubmit: () ->
      @listenToOnce(@vent, 'player:broadcast:response', (response) =>
        seconds_timecode = response.currentTime.toFixed(2);
        annotation = new AnnotationModel({
          attachment_id: @model.attachment.id
          body: @ui.input.val()
          published: false
          seconds_timecode: seconds_timecode
        })
        annotation.save({},{
          success: (annotation) =>
            @collection.add(annotation)
            @vent.trigger('error:clear')
            @vent.trigger('error:add', {level: 'notice', lifetime: 3000, msg: 'annotation successfully added'})
            @render()
            @vent.triggerMethod('player:start', {})
          error: (annotation, xhr) =>
            @vent.trigger('error:clear')
            @vent.trigger('error:add', {level: 'error', msg: xhr.responseJSON.errors})
        })

      )

      @vent.triggerMethod('player:broadcast:request', {})
