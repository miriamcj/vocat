define ['backbone'], (Backbone) ->

  class AbstractModel extends Backbone.Model

    toPositiveInt: (string) ->
      n = ~~Number(string)
      if String(n) == string && n >= 0 then n else null

    addError: (errorsObject, property, message) ->
      unless errorsObject[property] && _.isArray(errorsObject[property]) then errorsObject[property] = []
      errorsObject[property].push(message)

