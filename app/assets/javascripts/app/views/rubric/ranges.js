/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let RangesView;
const Marionette = require('marionette');
const template = require('hbs!templates/rubric/ranges');
const RangeView = require('views/rubric/range');
const jqui = require('jquery_ui');

export default RangesView = (function() {
  RangesView = class RangesView extends Marionette.CompositeView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.className = 'ranges-wrapper';
      this.prototype.childViewContainer = '[data-region="range-columns"]';
      this.prototype.childView = RangeView;

      this.prototype.ui = {
        rangeAdd: '.range-add-button',
        rangeInstruction: '.range-instruction'
      };
    }

    childViewOptions() {
      return {
      collection: this.collection,
      rubric: this.rubric,
      criteria: this.criteria,
      vent: this.vent
      };
    }

    childEvents() {
      return {
        'move:right': 'moveRight',
        'move:left': 'moveLeft'
      };
    }

    // This function validates the values array to make sure
    // there are enough values, no duplicates, etc.
    fixValues(values) {
      let newValues = values.slice(0); // clone it
      const sortIterator = function(aValue) {
        let out;
        return out = parseInt(aValue);
      };

      newValues = _.sortBy(newValues, sortIterator);

      // And add the correct high and low values
      newValues.push(this.rubric.get('low'));
      newValues.push(this.rubric.get('high'));
      newValues = _.uniq(newValues);

      const targetCount = this.collection.length + 1;
      newValues = _.filter(newValues, value => {
        return (value <= this.rubric.get('high')) && (value >= this.rubric.get('low'));
      });

      newValues = _.sortBy(newValues, sortIterator);

      let missingCount = targetCount - newValues.length;
      if ((missingCount < 0) && (newValues.length > 2)) {
        newValues.splice(1, 1);
      }

      newValues = _.uniq(newValues);

      while (missingCount > 0) {
        const bestGuess = this.guessNextValue(newValues);
        if (bestGuess != null) { newValues.push(bestGuess); }
        newValues = _.sortBy(newValues, sortIterator);
        missingCount--;
      }
      return newValues;
    }


    guessNextValue(values) {
      const gap = this.getLargestGapInSequence(values);
      const guess = Math.floor((_.reduce(gap, (memo, num) => memo + num) / 2));
      return guess;
    }

    getLargestGapInSequence(sequence) {
      let out;
      const maxRanges = (_.max(sequence) - _.min(sequence)) + 1;
      if (sequence.length === maxRanges) {
        out = [_.max(sequence), _.max(sequence)];
      } else {
        const gaps = _.map(sequence, function(value, index) {
          if (index !== 0) {
            let gap;
            return gap = value - sequence[index - 1] - 1;
          } else {
            return 0;
          }
        });
        const highIndex = _.indexOf(gaps, _.max(gaps));
        const lowIndex = highIndex - 1;
        out = [sequence[lowIndex], sequence[highIndex]];
      }
      return out;
    }

    getAvailableValues(sequence) {
      const counts = _.countBy(sequence, num => num);
      const min = _.min(sequence);
      const max = _.max(sequence);
      const all = __range__(min, max, true);
      const available = _.filter(all, num => (_.indexOf(sequence, num, true) === -1) || ((num === max) && (counts[num] <= 2) ));
      return available;
    }

    // Returns an array of numbers that are missing from the sequence. Assumes
    // sequence is already sorted.
    getMissingFromSequence(sequence) {
      const missing = [];
      for (let i = 0; i < sequence.length; i++) {
        const value = sequence[i];
        if ((sequence[i + 1] - sequence[i]) !== 1) {
          const x = sequence[i + 1] - sequence[i];
          let j = 1;
          while (j < x) {
            missing.push(sequence[i] + j);
            j++;
          }
        }
      }
      return missing;
    }

    // Updates the ranges collection from the current values
    updateCollection(values) {
      if (this.collection.length > 0) {
        const updates = [];
        _.each(values, (value, index) => {
        // Unless it's not the last one
          if ((index + 1) !== values.length) {
            let high, low;
            if (index === 0) {
              low = value;
            } else {
              low = value;
            }
            if ((index + 1) === (values.length - 1)) {
              high = values[index + 1];
            } else {
              high = values[index + 1] - 1;
            }
            return updates.push({low, high});
          }
        });
        _.each(updates, (update, index) => {
          const range = this.collection.at(index);
          if (range != null) {
            return range.set(update);
          }
        });
        return this.appendRangeAdd();
      }
    }

    // Returns the values from the range collection
    getValuesFromCollection(collection) {
      if (collection.length > 0) {
        let values = collection.pluck('low');
        values = _.sortBy(values, value => parseInt(value));
        return values;
      } else {
        return [];
      }
    }

    moveRight(childView) {
      const currentPosition = $('[data-region="cells"]').position();
      this.collection.comparator = 'index';
      this.model = childView.model;
      this.nextModel = this.collection.at(this.model.get('index') + 1);
      if (this.model.get('index') !== (this.collection.length - 1)) {
        this.model.set('index', this.model.get('index') + 1);
        this.nextModel.set('index', this.model.get('index') - 1);
        this.collection.sort();
        return this.vent.trigger('range:move:right', {currentPosition});
      }
    }

    moveLeft(childView) {
      const currentPosition = $('[data-region="cells"]').position();
      this.collection.comparator = 'index';
      this.model = childView.model;
      this.nextModel = this.collection.at(this.model.get('index') - 1);
      if (this.model.get('index') !== 0) {
        this.model.set('index', this.model.get('index') - 1);
        this.nextModel.set('index', this.model.get('index') + 1);
        this.collection.sort();
        return this.vent.trigger('range:move:left', {currentPosition});
      }
    }

    appendRangeAdd() {
      const rangeWrapper = $(this.el).find(this.childViewContainer);
      $(rangeWrapper).append(this.ui.rangeAdd);
      return $(rangeWrapper).append(this.ui.rangeInstruction);
    }

    showRangeAdd() {
      if (this.collection.length > 3) {
        return $(this.ui.rangeAdd).css('display', 'none');
      } else {
        return $(this.ui.rangeAdd).css('display', 'inline-block');
      }
    }

    showRangeInstruction() {
      if (this.collection.length > 0) {
        return $(this.ui.rangeInstruction).css('display', 'none');
      } else {
        return $(this.ui.rangeInstruction).css('display', 'inline-block');
      }
    }

    onShow() {
      this.showRangeAdd();
      return this.showRangeInstruction();
    }

    onRender() {
      return this.appendRangeAdd();
    }

    initialize(options) {
      this.vent = options.vent;
      this.rubric = options.rubric;
      this.criteria = options.criteria;
      return this.listenTo(this, 'add:child destroy:child remove:child', function() {
        let values = this.getValuesFromCollection(this.collection);
        values = this.fixValues(values);
        this.updateCollection(values);
        this.showRangeAdd();
        return this.showRangeInstruction();
      });
    }
  };
  RangesView.initClass();
  return RangesView;
})();

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}