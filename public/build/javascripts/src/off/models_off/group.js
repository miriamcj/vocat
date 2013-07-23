(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Models.Group = (function(_super) {
    __extends(Group, _super);

    function Group() {
      _ref = Group.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Group.prototype.validate = function(attributes, options) {
      var errors, out;

      console.log('called validation');
      console.log(attributes);
      errors = [];
      if ((attributes.name == null) || attributes.name === '') {
        errors.push({
          level: 'error',
          message: 'Please enter a name before creating the group'
        });
      }
      if (errors.length > 0) {
        out = errors;
      } else {
        out = false;
      }
      return out;
    };

    return Group;

  })(Backbone.Model);

}).call(this);
