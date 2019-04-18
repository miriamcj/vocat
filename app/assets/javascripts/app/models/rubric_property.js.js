define ['backbone'], (Backbone) ->
  class RubricProperty extends Backbone.Model

    errorStrings: {}
    idAttribute: "id"

    hasErrors: () ->
      if @errors.length > 0 then true else false

    errorMessages: () ->
      messages = new Array
      _.each(@errors, (error, index, list) =>
        if @errorStrings[error]?
          message = @errorStrings[error]
        else
          message = error
        messages.push(message)
      )
      messages

    initialize: () ->
      if !@get('id')? then @set('id', @cid.replace('c', ''))
      @errors = new Array

    addError: (key) ->
      _.each(@errors, (error, index, list) ->
        if error == key then list.splice(index, 1)
      )
      @errors.push(key)

    removeError: (error_key) ->
      errors = _.uniq(@errors, false)
      @errors = _.reject(errors, (error) =>
        error == error_key
      )
