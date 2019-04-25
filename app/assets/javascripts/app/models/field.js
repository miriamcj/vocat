import { clone } from "lodash";
import RubricProperty from 'models/rubric_property';

export default class FieldModel extends RubricProperty.extend({
  defaults: {
    name: '',
    description: '',
    range_descriptions: {}
  },

  errorStrings: {
    dupe: 'Duplicate field names are not allowed'
  }
}) {
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
    const descriptions = clone(this.get('range_descriptions'));
    descriptions[range.id] = description;
    this.set('range_descriptions', descriptions);
    return this.trigger('change');
  }
}
