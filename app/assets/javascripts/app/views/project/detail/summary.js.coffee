define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/summary')

  class ProjectDetailSummaryView extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @summary = Marionette.getOption(@, 'summary')

    serializeData: () ->
      @summary.project.video_percentage = 100 * (@summary.project.video_count / @summary.project.possible_submission_count)
      @summary

