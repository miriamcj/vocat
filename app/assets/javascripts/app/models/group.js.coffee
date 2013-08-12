define ['backbone'], (Backbone) ->

  class Group extends Backbone.Model

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
