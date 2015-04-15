define ['backbone', 'marionette', 'models/evaluation'], (Backbone, Marionette, EvaluationModel) ->
  class EvaluationCollection extends Backbone.Collection

    model: EvaluationModel

    initialize: (models, options) ->
      @options = options
      @courseId = Marionette.getOption(@, 'courseId')

    url: () ->
      "/api/v1/courses/#{@courseId}/evaluations"