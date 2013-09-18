define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_create')
  VideoModel = require('models/video')
  Poller = require('app/plugins/backbone_poller')
  FileUpload = require('vendor/plugins/file_upload')

  class PlayerCreate extends Marionette.Layout

    ui: {
      stage: '[data-ui="stage"]'
      createIntro: '[data-ui="create-intro"]'
      step1: '[data-ui="step1"]'
      step2: '[data-ui="step2"]'
      step3: '[data-ui="step3"]'
      step4: '[data-ui="step4"]'
      step5: '[data-ui="step5"]'
      step6: '[data-ui="step6"]'
      step7: '[data-ui="step7"]'
      step8: '[data-ui="step8"]'
      sourceIdYoutube: '[data-ui="source-id-youtube"]'
      sourceIdVimeo: '[data-ui="source-id-vimeo"]'
      youTubeWrap: '[data-ui="youtube-wrap"]'
      vimeoWrap: '[data-ui="vimeo-wrap"]'
      upload: '[data-behavior="async-upload"]'
    }

    triggers: {
      'click [data-behavior="show-step1"]': 'show:step:1'
      'click [data-behavior="show-step2"]': 'show:step:2'
      'click [data-behavior="show-step3"]': 'show:step:3'
      'click [data-behavior="show-step4"]': 'show:step:4'
      'click [data-behavior="show-step5"]': 'show:step:5'
      'click [data-behavior="close-create-ui"]': 'close:create:ui'
      'click [data-behavior="submit-youtube"]': 'submit:youtube'
      'click [data-behavior="submit-vimeo"]': 'submit:vimeo'
    }

    saveModel: (attributes) ->
      @model.save({video_attributes: attributes},{url: @model.updateUrl(), success: () =>
        @hideAllSteps()
        @model.fetch({url: @model.updateUrl()})
      })

    onSubmitYoutube: () ->
      value = @ui.sourceIdYoutube.val()
      matches = value.match(/v=([^&#]{5,})/)
      if matches? && matches.length > 0 && typeof matches[1] == 'string'
        attributes = {
          source: 'youtube'
          source_id: matches[1]
        }
        @saveModel(attributes)
        @ui.youTubeWrap.removeClass('error')
      else
        @ui.youTubeWrap.addClass('error')

    onSubmitVimeo: () ->
      value = @ui.sourceIdVimeo.val()
      matches = value.match(/^.+vimeo.com\/(.*\/)?([^#\?]*)/)
      id = if matches then matches[2] || matches[1] else null
      if id
        attributes = {
          source: 'vimeo'
          source_id: @ui.sourceIdVimeo.val()
        }
        @saveModel(attributes)
        @ui.vimeoWrap.removeClass('error')
      else
        @ui.vimeoWrap.addClass('error')

    initializeAsyncUploader: () ->
      @ui.upload.fileupload({
        url: "/api/v1/videos?submission=#{@model.id}"
        dataType: 'json'
        done: (e, data) =>
          @video = new VideoModel(data.result)
          @vent.triggerMethod('video:upload:done')
          @showStep(8)
          @vent.triggerMethod('video:transcoding:started')
          @startPolling(@video)
        fail: (e, data) =>
          @vent.triggerMethod('video:upload:failed')
          @showStep(7)
        send: (e, data) =>
          @vent.triggerMethod('video:upload:started')
          @showStep(6)
      })

    onRender: () ->

    onShow: () ->
      @showStep(1, false)

    centerContent: () ->
      @$el.find('.wrap').each( (index, el) ->
        $el = $(el)
        height = $el.outerHeight()
        parentHeight = $el.closest('.player-scene').outerHeight()
        $el.css({marginTop: (parentHeight / 2) - (height / 2)})
      )

    hideAllSteps: () ->
      @$el.find('.player-scene:visible').hide

    showStep: (step, fade = true) ->
      @$el.find('.player-scene:visible').fadeOut(200)
      $el = @ui[ "step#{step}" ]
      if fade
        $el.fadeIn({duration: 200, start: () => @centerContent()})
      else
        $el.show()
        setTimeout(
          () => @centerContent()
        , 0)

    onRender: () ->
      @initializeAsyncUploader()

    startPolling: (video) ->
      options = {
        delay: 5000
        delayed: true
        condition: (video) =>
          if video.get('attachment_transcoding_status') == 1
            @vent.triggerMethod('video:transcoding:completed', {video: video})
            @model.fetch({url: @model.updateUrl()})
            out = false
          else
            out = true
          out
      }

      poller = Poller.get(video, options);
      poller.start()

    onShowStep1: () ->
      @showStep(1)

    onShowStep2: () ->
      @showStep(2)

    onShowStep3: () ->
      @showStep(3)

    onShowStep4: () ->
      @showStep(4)

    onShowStep5: () ->
      @showStep(5)

    onCloseCreateUi: () ->
      @ui.createIntro.slideDown()

    template: template

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

