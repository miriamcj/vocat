define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/project_submission_row')

  class ProjectSubmissionRowView extends Marionette.ItemView

    tagName: "tr",
    template: template

    triggers: {
    }

    ui: {
    }

    initialize: (options) ->
      @options = options || {}
      @setupListeners()

    setupListeners: () ->
