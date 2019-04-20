import 'styles/stylesheets/main.scss';

import modernizr from 'modernizr';
const vjs = require("video.js");
const vjsContribHLS = require("videojs-contrib-hls");
const vjsYouTube = require('video_js/vjs.youtube');
const vjsVimeo = require('video_js/vjs.vimeo');

import Vocat from "vocat";

$(() =>
  // Start Vocat App
  Vocat.start()
);
