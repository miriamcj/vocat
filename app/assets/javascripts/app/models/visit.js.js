define ['backbone'], (Backbone) ->
  class VisitModel extends Backbone.Model

    url: () ->
      "/api/v1/visits"
      