/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/rubric_property'], function(Backbone, RubricProperty) {
  let FieldModel;
  return FieldModel = (function() {
    FieldModel = class FieldModel extends RubricProperty {
      static initClass() {
  
        this.prototype.defaults = {
          name: '',
          description: '',
          range_descriptions: {}
        };
  
        this.prototype.errorStrings = {
          dupe: 'Duplicate field names are not allowed'
        };
      }

      isNew() {
        return true;
      }

      validate(attr, options) {
        if (attr) {
          if (attr.name.length < 1) {
            return 'Criteria name must be at least one character long.';
          }
        }
      }


      setDescription(range, description) {
        const descriptions = _.clone(this.get('range_descriptions'));
        descriptions[range.id] = description;
        this.set('range_descriptions', descriptions);
        return this.trigger('change');
      }
    };
    FieldModel.initClass();
    return FieldModel;
  })();
});