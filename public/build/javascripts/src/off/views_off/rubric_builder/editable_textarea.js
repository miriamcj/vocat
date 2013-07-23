(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.RubricBuilderEditableTextarea = (function(_super) {
    __extends(RubricBuilderEditableTextarea, _super);

    function RubricBuilderEditableTextarea() {
      _ref = RubricBuilderEditableTextarea.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RubricBuilderEditableTextarea.prototype.template = HBT["app/templates/rubric_builder/editable_textarea"];

    return RubricBuilderEditableTextarea;

  })(Vocat.Views.RubricBuilderAbstractEditable);

}).call(this);
