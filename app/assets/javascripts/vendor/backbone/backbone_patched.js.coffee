define ['vendor/backbone/backbone_1.1.2'], (Backbone) ->

  sync = Backbone.sync

  Backbone.sync = (method, model, options) ->
    token = window.VocatAccessToken
    if !options.hasOwnProperty('headers')
      options.headers = {}
    options.headers['Authorization'] = "Bearer #{token}"
    sync.call(model, method, model, options);
  Backbone
