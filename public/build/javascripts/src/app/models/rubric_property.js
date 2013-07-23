(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var RubricProperty, _ref;

    return RubricProperty = (function(_super) {
      __extends(RubricProperty, _super);

      function RubricProperty() {
        _ref = RubricProperty.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      RubricProperty.prototype.errorStrings = {};

      RubricProperty.prototype.idAttribute = "id";

      RubricProperty.prototype.hasErrors = function() {
        if (this.errors.length > 0) {
          return true;
        } else {
          return false;
        }
      };

      RubricProperty.prototype.errorMessages = function() {
        var messages,
          _this = this;

        messages = new Array;
        _.each(this.errors, function(error, index, list) {
          var message;

          if (_this.errorStrings[error] != null) {
            message = _this.errorStrings[error];
          } else {
            message = error;
          }
          return messages.push(message);
        });
        return messages;
      };

      RubricProperty.prototype.initialize = function() {
        if (this.get('id') == null) {
          this.set('id', this.cid.replace('c', ''));
        }
        return this.errors = new Array;
      };

      RubricProperty.prototype.addError = function(key) {
        _.each(this.errors, function(error, index, list) {
          if (error === key) {
            return list.splice(index, 1);
          }
        });
        return this.errors.push(key);
      };

      RubricProperty.prototype.removeError = function(error_key) {
        var errors,
          _this = this;

        errors = _.uniq(this.errors, false);
        return this.errors = _.reject(errors, function(error) {
          return error === error_key;
        });
      };

      return RubricProperty;

    })(Backbone.Model);
  });

}).call(this);
