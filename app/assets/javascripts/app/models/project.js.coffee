define ['backbone'], (Backbone) ->

  class ProjectModel extends Backbone.Model

    urlRoot: "/api/v1/projects"