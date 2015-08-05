define (require) ->
  Backbone = require('backbone')

  class ProjectStatisticsModel extends Backbone.Model

    url: () ->
      "/api/v1/projects/#{@id}/statistics"