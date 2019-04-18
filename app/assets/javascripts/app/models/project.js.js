define ['backbone'], (Backbone) ->
  class ProjectModel extends Backbone.Model

    urlRoot: "/api/v1/projects"

    hasRubric: () ->
      _.isObject(@get('rubric'))

    pastDue: () ->
      due = @get('due_date')
      if due
        dueDate = new Date(due)
        if dueDate < new Date()
          true
        else
          false
      else
        false

    evaluatable: () ->
      @get('evaluatable')
