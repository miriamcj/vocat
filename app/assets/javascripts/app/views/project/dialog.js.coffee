define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/project/dialog')

  class ProjectDialogView extends Marionette.ItemView

    template: template

    initialize: () ->
      @model.fetch()