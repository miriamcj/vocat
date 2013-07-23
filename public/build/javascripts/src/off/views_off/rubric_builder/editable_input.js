(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.RubricBuilderEditableInput = (function(_super) {
    __extends(RubricBuilderEditableInput, _super);

    function RubricBuilderEditableInput() {
      _ref = RubricBuilderEditableInput.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RubricBuilderEditableInput.prototype.template = HBT["app/templates/rubric_builder/editable_input"];

    return RubricBuilderEditableInput;

  })(Vocat.Views.RubricBuilderAbstractEditable);

}).call(this);
