define ['backbone', 'models/submission'], (Backbone, ProjectModel) ->

  class PortfolioUnsubmittedCollection extends Backbone.Collection

    model: ProjectModel

    url: () ->
      "/api/v1/portfolio/unsubmitted"
