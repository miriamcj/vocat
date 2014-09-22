define (require) ->

  marionette = require('marionette')
  template = require('hbs!templates/course/manage/projects/project_row')

  class ProjectRowView extends Marionette.ItemView

    template: template
    tagName: 'tr'

    events: {
      "drop": "onDrop"
    }

    onDrop: (e, i) ->
      @trigger("update-sort",[@model, i]);
      console.log 'triggering update-sort'


    initialize: (options) ->
