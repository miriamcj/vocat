define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_layout')
  PlayerShowView = require('views/submission/player/player_show')
  PlayerCreateView = require('views/submission/player/player_create')
  PlayerMessageView = require('views/submission/player/player_message')
  PlayerProcessingView = require('views/submission/player/player_processing')
  Poller = require('app/plugins/backbone_poller')

  class PlayerLayout extends Marionette.LayoutView

    template: template

    regions: {
      playerMain: '[data-region="player-main"]'
    }

    polling: false

    onShow: () ->
      @selectView()

    startPolling: (video) ->
      if @polling == false
        options = {
          delay: 30000
          delayed: true
          condition: (video) =>
            if video.get('state') == 'processed'
              @model.fetch({
                url: @model.updateUrl(),
                success: () =>
                  @model.trigger('change:has_video')
              })
              @polling == false
              out = false
            else
              @polling == true
              out = true
            out
        }
        poller = Poller.get(video, options);
        poller.start()
        @polling = true


    selectView: () ->
      msg = ''
      if @model.get('has_video') && @model.video?
        switch @model.video.get('state')
          when 'processed'
            view = PlayerShowView
          when 'processing_error'
            view = PlayerProcessingView
            msg = "Processing Error: #{@model.video.get('processing_error')}"
          when 'processing'
            view = PlayerProcessingView
            msg = "Processing Video. Check back in 5-10 minutes."
            # TODO: Re-enable polling.
            #@startPolling(@model.video)
          else
            view = PlayerProcessingView
            msg = 'Unable to Process. Contact Support.'
      else if @model.get('current_user_can_attach')
        view = PlayerCreateView
        @playerMain.show new PlayerCreateView({vent: @, model: @model})
      else
        view = PlayerMessageView
        msg = 'No video has been uploaded. Check back soon.'
      @playerMain.show new view({vent: @vent, model: @model, message: msg})

    initialize: (options) ->
      @vent = options.vent
      @listenTo(@model,'change:has_video', (model) =>
        @selectView()
      )
