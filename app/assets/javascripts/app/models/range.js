/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/rubric_property'], function(Backbone, RubricProperty) {
  let RangeModel;
  return RangeModel = (function() {
    RangeModel = class RangeModel extends RubricProperty {
      static initClass() {
  
        this.prototype.errorStrings = {
          high_gap: 'There is a gap or an overlap between the high end of this range and the low end of the next range.',
          low_gap: 'There is a gap or an overlap between the low end of this range and the high end of the previous range.',
          range_inverted: 'The high end of this range is lower than the low end.',
          no_name: 'All ranges must have a name.',
          dupe: 'All ranges must have a unique name.'
        };
  
        this.prototype.modalOpened = false;
  
        this.prototype.defaults = {
          name: '',
          low: 0,
          high: 1
        };
      }

      isNew() {
        return true;
      }

      position() {
        if (!this.collection) { return null; }
        return this.collection.indexOf(this);
      }

      percentage() {
        if (!this.position()) { return 0; }
        if (!(this.collection.length > 0)) { return 0; }
        return this.position() / this.collection.length;
      }


      toJSON() {
        const out = super.toJSON();
        out.position = this.position();
        out.percentage = this.percentage();
        return out;
      }

      validate(attr, options) {
        if (attr) {
          if (attr.name.length < 1) {
            return 'Range name must be at least one character long.';
          }
        }
      }
    };
    RangeModel.initClass();
    return RangeModel;
  })();
});

