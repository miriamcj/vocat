const path = require("path");
const webpack = require('webpack');

module.exports = {
  module: {
    rules: [
      {
        loader: "webpack-modernizr-loader",
        test: /\.modernizrrc\.js$/
      },
      {
        test: /\.hbs$/,
        loader: "handlebars-loader",
        options: {
          helperDirs: [path.join(__dirname, "../../app/assets/javascripts/app/helpers")]
        }
      }
    ]
  },
  resolve: {
    alias: {
      modernizr$: path.resolve(__dirname, "./.modernizrrc.js")
    }
  },
  plugins: [
    new webpack.ProvidePlugin({
       Backbone: 'backbone',
       Marionette: 'backbone.marionette',
       '_': 'underscore',
       $: 'jquery',
       jQuery: 'jquery',
       jquery: 'jquery',
       Vocat: 'vocat',
       'window.videojs': 'video_js/video.js',
       Handlebars: 'handlebars'
    })
  ]
};
