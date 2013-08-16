define ['backbone'], (Backbone) ->

  class Group extends Backbone.Model

    urlRoot: () ->
      "/api/v1/courses/#{@get('course_id')}/groups"

    validate: (attributes, options) ->
      errors = []
      if !attributes.name? || attributes.name == ''
        errors.push
          level: 'error'
          message: 'Please enter a name before creating the group'
      if errors.length > 0
        out = errors
      else
        out = false
      out
