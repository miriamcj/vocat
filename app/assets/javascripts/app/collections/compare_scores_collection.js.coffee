define (require) ->
  Backbone = require('backbone')
  Marionette = require('marionette')
  CompareScoresModel = require('models/compare_scores')

  class CompareScoresCollection extends Backbone.Collection

    model: CompareScoresModel

    queryParams: {
      left: null
      right: null
    }

    initialize: (models, options) ->
      @options = options
      @projectId = Marionette.getOption(@, 'projectId')

    updateQueryParams: (left, right) ->
      @queryParams = {
        left: left
        right: right
      }

    url: () ->
      "/api/v1/projects/#{@projectId}/compare_scores?left=#{@queryParams.left}&right=#{@queryParams.right}"