define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_layout')
  PlayerShowView = require('views/submission/player/player_show')
  PlayerCreateView = require('views/submission/player/player_create')
  PlayerMessageView = require('views/submission/player/player_message')

  class PlayerLayout extends Marionette.Layout

    template: template

    regions: {
      playerMain: '[data-region="player-main"]'
    }

    onRender: () ->
      @selectView()

    selectView: () ->
      msg = ''
      if @model.get('has_video') == true
        view = PlayerShowView
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
