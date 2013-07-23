(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'jquery_rails'], function(Marionette, $) {
    var VocatController, _ref;

    return VocatController = (function(_super) {
      __extends(VocatController, _super);

      function VocatController() {
        _ref = VocatController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      VocatController.prototype.collections = {};

      VocatController.prototype.initialize = function() {
        return this.bootstrapCollections();
      };

      VocatController.prototype.isBlank = function(str) {
        if (str === null) {
          str = '';
        }
        return /^\s*$/.test(str);
      };

      VocatController.prototype.bootstrapCollections = function() {
        var _this = this;

        return _.each(this.collections, function(collection, collectionKey) {
          var data, dataContainer, div, text;

          dataContainer = $("#bootstrap-" + collectionKey);
          if (dataContainer.length > 0) {
            div = $('<div></div>');
            div.html(dataContainer.text());
            text = div.text();
            if (!_this.isBlank(text)) {
              data = JSON.parse(text);
              if (data[collectionKey] != null) {
                return collection.reset(data[collectionKey]);
              }
            }
          }
        });
      };

      return VocatController;

    })(Marionette.Controller);
  });

}).call(this);
