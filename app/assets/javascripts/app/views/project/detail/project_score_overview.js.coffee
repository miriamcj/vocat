define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/project_score_overview')

  class ProjectScoreOverview extends Marionette.ItemView

    template: template

    triggers: {

    }

    ui: {

    }

    initialize: (options) ->
      @options = options || {}
      @setupListeners()

    setupListeners: () ->
      @listenTo(@model, 'sync', () => @render())
