define ['backbone'], (Backbone) ->

  class Group extends Backbone.Model

    creatorType: 'Group'

    urlRoot: '/api/v1/groups'

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

    takeSnapshot: () ->
      @_snapshotAttributes = _.clone @attributes

    revert: () ->
      @set(@_snapshotAttributes, {}) if @_snapshotAttributes

    initialize: () ->
      @takeSnapshot()
      @.on('sync', () =>
        @takeSnapshot()
      )