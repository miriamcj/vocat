define [], () ->

  (collection) ->

    filtered = new collection.constructor()
    filtered._callbacks = {}

    filtered.where = (criteria) ->
      if _.isFunction(criteria)
        items = collection.filter(criteria)
      else if _.isHash(criteria)
        items = collection.where(criteria)
      else
        items = collection.models

      filtered._currentCriteria = criteria
      filtered.reset(items)

    collection.on 'reset add remove', (event) ->
      filtered.where(filtered._currentCriteria)

    filtered
