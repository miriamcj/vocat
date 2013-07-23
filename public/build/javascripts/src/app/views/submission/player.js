(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/partials/player_has_transcoded_video', 'hbs!templates/submission/partials/player_no_video', 'models/attachment'], function(Marionette, templateVideo, templateNoVideo, Attachment) {
    var PlayerView, _ref;

    return PlayerView = (function(_super) {
      __extends(PlayerView, _super);

      function PlayerView() {
        _ref = PlayerView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PlayerView.prototype.getTemplate = function() {
        var template;

        template = templateVideo;
        return template;
      };

      PlayerView.prototype.triggers = {
        'click [data-behavior="destroy"]': 'destroy',
        'click [data-behavior="request-transcoding"]': 'start:transcoding'
      };

      PlayerView.prototype.ui = {
        player: '[data-behavior="video-player"]'
      };

      PlayerView.prototype.onStartTranscoding = function(e) {
        return this.model.requestTranscoding();
      };

      PlayerView.prototype.onDestroy = function() {
        var _this = this;

        return this.model.destroy({
          success: function() {
            _this.model.clear();
            return _this.vent.triggerMethod('attachment:destroyed');
          }
        });
      };

      PlayerView.prototype.initialize = function(options) {
        var _this = this;

        this.options = options || {};
        this.submission = Marionette.getOption(this, 'submission');
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.listenTo(this.model, 'change', function(options) {
          return _this.render();
        });
        this.listenTo(this.vent, 'player:stop', function(options) {
          return _this.onPlayerStop(options);
        });
        this.listenTo(this.vent, 'player:start', function(options) {
          return _this.onPlayerStart(options);
        });
        this.listenTo(this.vent, 'player:seek', function(options) {
          return _this.onPlayerSeek(options);
        });
        return this.listenTo(this.vent, 'player:broadcast:request', function(options) {
          return _this.onPlayerBroadcastRequest(options);
        });
      };

      PlayerView.prototype.onPlayerStop = function() {
        return this.player.pause();
      };

      PlayerView.prototype.onPlayerStart = function() {
        return this.player.play();
      };

      PlayerView.prototype.onPlayerSeek = function(options) {
        return this.player.currentTime(options.seconds);
      };

      PlayerView.prototype.onRender = function() {
        var _this = this;

        if (this.model && this.model.get('is_video')) {
          Popcorn.player('baseplayer');
          this.player = Popcorn(this.ui.player[0]);
          return this.player.on('timeupdate', _.throttle(function() {
            return _this.vent.trigger('player:time', {
              seconds: _this.player.currentTime().toFixed(2)
            });
          }, 500));
        }
      };

      PlayerView.prototype.onPlayerBroadcastRequest = function() {
        return this.vent.trigger('player:broadcast:response', {
          currentTime: this.player.currentTime()
        });
      };

      return PlayerView;

    })(Marionette.ItemView);
  });

}).call(this);
