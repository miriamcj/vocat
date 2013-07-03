define ['backbone', 'models/submission'], (Backbone, SubmissionModel) ->

  class PortfolioCollection extends Backbone.Collection

    model: SubmissionModel

    url: () ->
      "/api/v1/portfolio"
