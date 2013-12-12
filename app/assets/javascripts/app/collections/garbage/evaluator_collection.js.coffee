define ['backbone', 'collections/user_collection', 'models/evaluator'], (Backbone, UserCollection, EvaluatorModel) ->

  class EvaluatorCollection extends UserCollection

    courseId = null
    model: EvaluatorModel

    url: () ->
      "/api/v1/courses/#{@courseId}/evaluators"

    initialize: () ->
      @listenTo(@, 'add', (model) =>
        model.courseId = @courseId
      )