(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.RubricBuilderAbstractEditable = (function(_super) {
    __extends(RubricBuilderAbstractEditable, _super);

    function RubricBuilderAbstractEditable() {
      _ref = RubricBuilderAbstractEditable.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RubricBuilderAbstractEditable.prototype.defaults = {
      editing: false,
      property: '',
      name: 'Type here'
    };

    RubricBuilderAbstractEditable.prototype.events = {
      'click .js-do-close': 'doClose',
      'click .js-do-open': 'doOpen',
      'submit form': 'doSave',
      'click .js-save': 'doSave',
      'focus input': 'doSelect'
    };

    RubricBuilderAbstractEditable.prototype.initialize = function(options) {
      this.model = options.model;
      this.options = _.clone(_.extend(this.defaults, this.options));
      this.initializeState();
      this.state.bind('change:editing', this.render, this);
      return this.render();
    };

    RubricBuilderAbstractEditable.prototype.doSelect = function(event) {
      return this.$el.find('.editable-inline-input').select();
    };

    RubricBuilderAbstractEditable.prototype.doOpen = function(event) {
      event.preventDefault();
      event.stopPropagation();
      this.editingOn();
      return this.$el.find('.editable-inline-input').focus();
    };

    RubricBuilderAbstractEditable.prototype.doClose = function(event) {
      event.preventDefault();
      event.stopPropagation();
      return this.editingOff();
    };

    RubricBuilderAbstractEditable.prototype.doSave = function(event) {
      event.preventDefault();
      event.stopPropagation();
      this.model.set(this.options.property, this.$el.find('.editable-inline-input').val());
      return this.editingOff();
    };

    RubricBuilderAbstractEditable.prototype.editingOn = function() {
      if (this.state.get('editing') === false) {
        return this.state.set('editing', true);
      }
    };

    RubricBuilderAbstractEditable.prototype.editingOff = function() {
      if (this.state.get('editing') === true) {
        return this.state.set('editing', false);
      }
    };

    RubricBuilderAbstractEditable.prototype.initializeState = function() {
      return this.state = new Vocat.Models.ViewState({
        editing: this.options.editing
      });
    };

    RubricBuilderAbstractEditable.prototype.render = function(event) {
      var context;

      if (event == null) {
        event = null;
      }
      context = {
        property: this.options.property,
        placeholder: this.options.placeholder,
        editing: this.state.get('editing'),
        value: this.model.get(this.options.property)
      };
      return this.$el.html(this.template(context));
    };

    return RubricBuilderAbstractEditable;

  })(Vocat.Views.AbstractView);

}).call(this);
