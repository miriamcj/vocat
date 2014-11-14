define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_create')
  iFrameTransport= require('vendor/plugins/iframe_transport')
  FileUpload = require('vendor/plugins/file_upload')

  class PlayerCreate extends Marionette.LayoutView

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

    template: template

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

    serializeData: () ->
      sd = {
        s3Bucket: window.VocatS3Bucket
        AWSPublicKey: window.VocatAWSPublicKey
      }
      sd

    saveModel: (attributes) ->
      @model.save({video_attributes: attributes},{url: @model.updateUrl(), success: () =>
        @hideAllSteps()
        @model.fetch({url: @model.updateUrl(), success: () =>
          @vent.triggerMethod('video:created')
        })
      })

    onSubmitYoutube: () ->
      value = @ui.sourceIdYoutube.val()
      matches = value.match(/(v=|\.be\/)([^&#]{5,})/)
      if matches? && matches.length > 0 && typeof matches[2] == 'string'
        attributes = {
          source: 'youtube'
          source_id: matches[2]
        }
        @saveModel(attributes)
        @ui.youTubeWrap.removeClass('field_with_errors')
      else
        @ui.youTubeWrap.addClass('field_with_errors')
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The Youtube URL you entered is invalid.'})

    onSubmitVimeo: () ->
      value = @ui.sourceIdVimeo.val()
      matches = value.match(/^.+vimeo.com\/(.*\/)?([^#\?]*)/)
      id = if matches then matches[2] || matches[1] else null
      if id
        attributes = {
          source: 'vimeo'
          source_id: id
        }
        @saveModel(attributes)
        @ui.vimeoWrap.removeClass('field_with_errors')
      else
        @ui.vimeoWrap.addClass('field_with_errors')
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The Vimeo URL you entered is invalid.'})

    initializeAsyncUploader: () ->
      attachmentId = null
      @ui.upload.fileupload({
        forceIframeTransport: true,
        autoUpload: true,
        add: (e, data) =>
          $.ajax({
            url: '/api/v1/attachments'
            type: 'POST'
            dataType: 'json'
            data: {attachment: {media_file_name: data.files[0].name}}
            async: false
            success: (retdata) =>
              attachmentId = retdata.attachment_id
              @ui.upload.find('input[name=key]').val(retdata.key)
              @ui.upload.find('input[name=policy]').val(retdata.policy)
              @ui.upload.find('input[name=signature]').val(retdata.signature)
              data.submit()
          })
        send: (e, data) =>
          @showStep(6)
        fail: (e, data) =>
          @showStep(7)
        done: (e, data) =>
          $.ajax({
            # This is a hack that should be fixed. It will come back to haunt you later.
            # Unsure where, exactly, to create the video object, and generally unhappy with the
            # attachment/video relationship, I put it here. When we commit the attachment,
            # we pass the submission ID and create a video record.
            url: "/api/v1/attachments/#{attachmentId}/commit?submission_id=#{@model.id}"
            type: 'POST'
            dataType: 'json'
            success: (data) =>
              @model.fetch({url: @model.updateUrl()}, success: () =>
                @model.trigger('change:video')
                @vent.triggerMethod('video:created')
              )
            fail: (data) =>
              @showStep(7)
          })
      })

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
      $el = @ui[ "step#{step}" ]
      if fade
        @$el.find('.player-scene:visible').fadeOut(200)
        $el.fadeIn({duration: 200, start: () => @centerContent()})
      else
        @$el.find('.player-scene:visible').hide()
        $el.show()
        setTimeout(
          () => @centerContent()
        , 0)

    onRender: () ->
      @initializeAsyncUploader()

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

    onDestroyCreateUi: () ->
      @ui.createIntro.slideDown()

