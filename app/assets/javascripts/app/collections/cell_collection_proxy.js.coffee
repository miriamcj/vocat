define [], () ->

  (collection) ->

    filtered = new collection.constructor()
    filtered._callbacks = {}

    filtered.where = (criteria) ->
      if criteria
        items = collection.where(criteria)
      else
        items = collection.models

      filtered._currentCriteria = criteria

      filtered.reset(items)

    collection.on 'reset add remove', () ->
      filtered.where(filtered._currentCriteria)

    filtered



