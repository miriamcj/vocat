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
        loader: "handlebars-loader"
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
       Backbone: ['backbone-shim', 'default'],
       Marionette: 'backbone.marionette',
       $: 'jquery',
       jQuery: 'jquery',
       jquery: 'jquery',
       Vocat: 'vocat',
       'window.videojs': 'video_js/video.js'
    })
  ]
};
