(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/upload/transcoding'], function(Marionette, template) {
    var UploadTranscodingView, _ref;

    return UploadTranscodingView = (function(_super) {
      __extends(UploadTranscodingView, _super);

      function UploadTranscodingView() {
        _ref = UploadTranscodingView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      UploadTranscodingView.prototype.template = template;

      UploadTranscodingView.prototype.onRender = function() {
        return console.log('test a');
      };

      return UploadTranscodingView;

    })(Marionette.ItemView);
  });

}).call(this);
