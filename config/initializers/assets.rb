# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(
  vendor/require/require.js
  vendor/modernizr/modernizr-2.6.2.js
  vendor/video_js/video.js
  vendor/video_js/vjs.youtube.js
  vendor/video_js/vjs.vimeo.js
  vendor/rem_unit_polyfill/rem.min.js
  apipie/apipie.css
  404.html,
  500.html,
  422.html
)
