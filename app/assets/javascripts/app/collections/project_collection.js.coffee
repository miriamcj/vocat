define ['backbone', 'models/project'], (Backbone, ProjectModel) ->

  class ProjectCollection extends Backbone.Collection
	  model: ProjectModel