requirejs.config {
  shim: {
    'jquery_ujs': ['jquery']
    'ui/jquery_ui': ['jquery']
    'plugins/smooth_scroll': ['jquery']
    'plugins/simple_slider': ['jquery']
    'plugins/iframe_transport': ['jquery']
    'plugins/file_upload': ['jquery']
    'plugins/autosize': ['jquery']
    'plugins/waypoints': ['jquery']
    'popcorn/popcorn' : []
  }

  hbs: {
    'disableI18n' : true
    'helperPathCallback' : (name) ->
      "app/helpers/#{name}"
  }

  paths: {
    'i18nprecompile' : 'hbs/i18nprecompile'
    'routers' : 'app/routers'
    'views' : 'app/views'
    'controllers' : 'app/controllers'
    'collections' : 'app/collections'
    'helpers' : 'app/helpers'
    'models' : 'app/models'
    'templates' : 'app/templates'
    'backbone' : 'backbone'
    'underscore' : 'underscore'
    'backbone.wreqr' : 'plugins/backbone.wreqr'
    'backbone.eventbinder' : 'plugins/backbone.eventbinder'
    'backbone.babysitter' : 'plugins/backbone.babysitter'
  }

  map: {

    # Any module that requests jquery gets jquery-with-rails-ujs instead. Likewise, any module that requests
    # Marionette gets the patched Marionette instead (for HBS template rendering)
    '*': {

      # The fileupload plugin asks for jquery.ui.widget, which is already included in jquery_ui.
      'jquery.ui.widget' : 'ui/jquery_ui'
      'jquery': 'jquery-with-rails-ujs'
      'marionette' : 'marionette_patched'
      'Handlebars': 'handlebars'
      'hbs/underscore': 'underscore'
    }

    # But, jquery_ujs, jquery-with-rails-ujs, and marionette_patched all get the original library so they can patch it.
    'marionette_patched': {
      'marionette': 'marionette'
    }
    'jquery_ujs': {
      'jquery': 'jquery'
    }
    'jquery-with-rails-ujs': {
      'jquery': 'jquery'
    }
  }
}

require ['jquery', 'layout/layout', 'plugins/simple_slider'], ($, Layout) ->
  Layout.bootstrap()

require ['jquery', 'app/vocat'], ($, Vocat) ->
  Vocat.start()


