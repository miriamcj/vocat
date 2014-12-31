define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/video_annotator')
  VideoProgressBarView = require('views/assets/annotator/video_progress_bar')
  AnnotationModel = require('models/annotation')

  class VideoAnnotatorView extends Marionette.LayoutView

    template: template

    ui:
      annotationInput: '[data-behavior="annotation-input"]'
      annotationPostButton: '[data-behavior="annotation-post"]'

    triggers: {
      'click @ui.annotationPostButton': 'saveAnnotation'
    }

    events:
      'keypress [data-behavior="annotation-input"]': 'onUserTyping'

    regions: {
      progressBar: '[data-behavior="progress-bar"]'
    }

    onUserTyping: () ->

    onSaveAnnotation: () ->
      @listenToOnce(@vent, 'announce:status', (response) =>
        seconds_timecode = response.playedSeconds;
        annotation = new AnnotationModel({
          asset_id: @model.id
          body: @ui.annotationInput.val()
          published: true
          seconds_timecode: seconds_timecode
        })
        annotation.save({},{
          success: (annotation) =>
            @collection.add(annotation)
          error: (annotation, xhr) =>
            Vocat.vent.trigger('error:add', {level: 'error', msg: xhr.responseJSON.errors})
        })
      )
      @vent.trigger('request:status', {})


    initialize: (options) ->
      @vent = options.vent
      @collection = @model.annotations()

    onShow: () ->
      @progressBar.show(new VideoProgressBarView({model: @model, vent: @vent, collection: @collection}))
