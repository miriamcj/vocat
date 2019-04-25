import 'styles/stylesheets/main.scss';

const videojs = window.videojs;
require("videojs-contrib-hls");
require('video_js/vjs.youtube');
require('video_js/vjs.vimeo');

require.context('styles/images', true);

require("vocat");

$(() => {
  // Start Vocat App
  window.Vocat.start()
});
