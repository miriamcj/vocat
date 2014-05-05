define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/project/project_detail')

  class ProjectDetailView extends Marionette.ItemView

    template: template

    initialize: () ->
      @model.fetch()