(function() {
  requirejs.config({
    shim: {
      'vendor/ui/jquery_ui': ['jquery_rails'],
      'vendor/plugins/smooth_scroll': ['jquery_rails'],
      'vendor/plugins/simple_slider': ['jquery_rails'],
      'vendor/plugins/iframe_transport': ['jquery_rails'],
      'vendor/plugins/file_upload': ['jquery_rails'],
      'vendor/plugins/autosize': ['jquery_rails'],
      'vendor/plugins/waypoints': ['jquery_rails']
    },
    hbs: {
      'disableI18n': true,
      'helperPathCallback': function(name) {
        return "app/helpers/" + name;
      }
    },
    paths: {
      'templates': 'app/templates',
      'routers': 'app/routers',
      'views': 'app/views',
      'controllers': 'app/controllers',
      'collections': 'app/collections',
      'helpers': 'app/helpers',
      'models': 'app/models',
      'hbs': 'vendor/require/hbs',
      'cs': 'vendor/require/coffee-script',
      'jquery_rails': 'vendor/jquery/jquery-with-rails-ujs',
      'i18nprecompile': 'vendor/hbs/i18nprecompile',
      'json2': 'vendor/hbs/json2',
      'handlebars': 'vendor/handlebars/handlebars',
      'backbone': 'vendor/backbone/backbone',
      'underscore': 'vendor/underscore/underscore',
      'backbone.wreqr': 'vendor/plugins/backbone.wreqr',
      'backbone.eventbinder': 'vendor/plugins/backbone.eventbinder',
      'backbone.babysitter': 'vendor/plugins/backbone.babysitter',
      'marionette': 'vendor/marionette/marionette',
      'jquery_ui': 'vendor/ui/jquery_ui'
    },
    map: {
      '*': {
        'jquery.ui.widget': 'vendor/ui/jquery_ui'
      }
    }
  });

  require(['layout/layout'], function(Layout) {
    return Layout.bootstrap();
  });

  require(['app/vocat'], function(Vocat) {
    return Vocat.start();
  });

}).call(this);
