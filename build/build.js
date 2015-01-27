({
//  optimize: 'none',
  // This allows us to find the nested dependencies in the Vocat object for dynamica router loading in dev.
  findNestedDependencies: 'true',
  baseUrl: "javascripts/src",
  fileExclusionRegExp: /^(off)$/,
  shim: {
    'jquery_ujs': ['jquery'],
    'vendor/ui/jquery_ui': ['jquery_rails'],
    'vendor/plugins/iframe_transport': ['jquery_rails'],
    'vendor/plugins/file_upload': ['jquery_rails'],
    'vendor/plugins/autosize': ['jquery_rails'],
    'vendor/plugins/chosen': ['jquery_rails'],
    'vendor/plugins/waypoints': ['jquery'],
    'vendor/plugins/waypoints_sticky': ['jquery'],
    'vendor/plugins/ajax_chosen': ['vendor/plugins/chosen'],
    'vendor/dc/dc': {
      deps: ['vendor/crossfilter/crossfilter', 'vendor/d3/d3'],
      exports: 'dc'
    },
    'vendor/paper/paper-full' : {
      exports: 'paper'
    },
    'vendor/crossfilter/crossfilter': {
      exports: 'crossfilter'
    },
    'vendor/d3/d3': {
      exports: 'd3'
    }
  },
  hbs: {
    'disableI18n': true,
    'partialsUrl': 'templates/partials',
    'helperPathCallback': function(name) {
      return "app/helpers/" + name;
    }
  },
  keepBuildDir: true,
  paths: {
    'templates': 'app/templates',
    'routers': 'app/routers',
    'views': 'app/views',
    'behaviors': 'app/behaviors',
    'controllers': 'app/controllers',
    'collections': 'app/collections',
    'helpers': 'app/helpers',
    'models': 'app/models',
    'hbs': 'vendor/require/hbs',
    'cs': 'vendor/require/coffee-script',
	  'jquery': 'vendor/jquery/jquery',
	  'jquery_ujs': 'vendor/jquery/jquery_ujs',
    'jquery_rails': 'vendor/jquery/jquery-with-rails-ujs',
    'i18nprecompile': 'vendor/hbs/i18nprecompile',
    'json2': 'vendor/hbs/json2',
    'handlebars': 'vendor/handlebars/handlebars',
    'backbone': 'vendor/backbone/backbone_1.1.2',
    'underscore': 'vendor/underscore/underscore',
    'backbone.wreqr': 'vendor/plugins/backbone.wreqr',
    'backbone.eventbinder': 'vendor/plugins/backbone.eventbinder',
    'backbone.babysitter': 'vendor/plugins/backbone.babysitter',
    'marionette': 'vendor/marionette/marionette_2.2.0',
    'jquery_ui': 'vendor/ui/jquery_ui',
    'waypoints': 'vendor/plugins/waypoints',
    'waypoints_sticky': 'vendor/plugins/waypoints_sticky',
    'wavesurfer': 'vendor/wavesurfer/wavesurfer'
  },
  out: '../public/build/bootstrap.js',
  name: 'bootstrap'
})
