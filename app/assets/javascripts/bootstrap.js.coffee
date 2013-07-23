requirejs.config {
  shim: {
#    'vendor/jquery/jquery-with-rails-ujs': ['vendor/jquery/jquery']
#    'jquery_ujs': ['jquery_rails']
    'vendor/ui/jquery_ui': ['jquery_rails']
    'vendor/plugins/smooth_scroll': ['jquery_rails']
    'vendor/plugins/simple_slider': ['jquery_rails']
    'vendor/plugins/iframe_transport': ['jquery_rails']
    'vendor/plugins/file_upload': ['jquery_rails']
    'vendor/plugins/autosize': ['jquery_rails']
    'vendor/plugins/waypoints': ['jquery_rails']
  }

  hbs: {
    'disableI18n' : true
    'helperPathCallback' : (name) ->
      "app/helpers/#{name}"
  }

  paths: {
    'templates' : 'app/templates'
    'routers' : 'app/routers'
    'views' : 'app/views'
    'controllers' : 'app/controllers'
    'collections' : 'app/collections'
    'helpers' : 'app/helpers'
    'models' : 'app/models'
    'hbs' : 'vendor/require/hbs'
    'cs' : 'vendor/require/coffee-script'
    'jquery_rails' : 'vendor/jquery/jquery-with-rails-ujs'
    'i18nprecompile' : 'vendor/hbs/i18nprecompile'
    'json2' : 'vendor/hbs/json2'
    'handlebars' : 'vendor/handlebars/handlebars'
    'backbone' : 'vendor/backbone/backbone'
    'underscore' : 'vendor/underscore/underscore'
    'backbone.wreqr' : 'vendor/plugins/backbone.wreqr'
    'backbone.eventbinder' : 'vendor/plugins/backbone.eventbinder'
    'backbone.babysitter' : 'vendor/plugins/backbone.babysitter'
  }

  map: {
    '*': {
      # The fileupload plugin asks for jquery.ui.widget, which is already included in jquery_ui.
      'jquery.ui.widget' : 'vendor/ui/jquery_ui'
      'marionette' : 'vendor/marionette/marionette_patched'
    }

    # But, jquery_ujs, jquery-with-rails-ujs, and marionette_patched all get the original library so they can patch it.
    'vendor/marionette/marionette_patched': {
      'marionette': 'vendor/marionette/marionette'
    }
  }
}

require ['layout/layout'], (Layout) ->
  Layout.bootstrap()

require ['app/vocat'], (Vocat) ->
  Vocat.start()



