const webpack = require('webpack');
const { environment } = require("@rails/webpacker");
const customConfig = require("./custom");

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery'
  })
);

environment.config.merge(customConfig);

module.exports = environment;
