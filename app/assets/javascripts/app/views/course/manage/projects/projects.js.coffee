define (require) ->

  marionette = require('marionette')
  ProjectCollection = require('collections/project_collection')
  template = require('hbs!templates/course/manage/projects/projects')
  ProjectsRowView = require('views/course/manage/projects/project_row')
  SortableTable = require('behaviors/sortable_table')

  class Projects extends Marionette.CompositeView

    template: template
    childView: ProjectsRowView
    childViewContainer: 'tbody'

    behaviors: {
      sortableTable: {
        behaviorClass: SortableTable
      }
    }

    initialize: (options) ->

