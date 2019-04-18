/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let RangePickerModalView;
  const template = require('hbs!templates/rubric/range_picker_modal');
  const jqui = require('jquery_ui');
  const Marionette= require('marionette');

  return RangePickerModalView = (function() {
    RangePickerModalView = class RangePickerModalView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.modalWidth = '90%';
        this.prototype.maxWidth = '1100px';
        this.prototype.className = "range-picker-modal";
  
        this.prototype.regions = {
          rangePicker: '[data-region="range-picker"]'
        };
  
        this.prototype.ui = {
          lowInput: '[data-behavior="rubric-low"]',
          highInput: '[data-behavior="rubric-high"]',
          draggableContainer: '[data-behavior="draggable-container"]',
          handles: '[data-handle]',
          rangePicker: '[data-behavior="range-picker"]',
          ticks: '[data-container="ticks"]'
        };
  
        this.prototype.events = {
          'keyup @ui.lowInput': 'lowChange',
          'keyup @ui.highInput': 'highChange'
        };
  
        this.prototype.fallBackWidth = 922;
      }

      lowChange(event) {
        return this.vent.triggerMethod('handle:low:change', this.ui.lowInput.val());
      }

      highChange(event) {
        return this.vent.triggerMethod('handle:high:change', this.ui.highInput.val());
      }

      // Snaps a dragger to the closest free tick.
      snapToTick($dragger, startPosition = null) {
        const values = this.getValues();
        const { left } = $dragger.position();
        let target = this.getScoreFromLeft(left);
        let movePreference = 'next';
        if ((startPosition != null) && (startPosition < target)) { movePreference = 'previous'; }

        // Does the target value appear more than once in the values array? If so, we need to shunt
        // the $dragger to a new position.
        if (_.filter(values, value => value !== target).length < (values.length - 1)) {
          const missing = this.getAvailableValues(values);
          // First we try to go up
          const nextViableTarget = _.min(_.reject(missing, value => value < target));
          const previousViableTarget = _.max(_.reject(missing, value => value > target));
          const nextDistance = this.getLeftFromScore(nextViableTarget) - left;
          const previousDistance = left - this.getLeftFromScore(previousViableTarget);
          if (nextDistance < previousDistance) { target = nextViableTarget; } else { target = previousViableTarget; }
        }
        return this.moveTo($dragger, target, true);
      }

      // Updates the handle label based on the $el's position
      updateLabel($el, left) {
        const score = this.getScoreFromLeft(left);
        return $el.find('.dragger-score').html(score);
      }

      // Called when the draggers are dragged. Currently only triggers a label update
      handlePositionChange(ui) {
        return this.updateLabel(ui.helper, ui.position.left);
      }

      // Returns the number of ticks to show for a given range (assuming we limit ticks to 10.
      getTickCountForRange(range) {
        let ticks = 0;
        _.each(__range__(0, range, true), function(i) {
          if (((range % i) === 0) && (i <= 15)) {
            return ticks = i;
          }
        });
        if (range <= 15) {
          ticks === range;
        } else if (ticks < 5) {
          ticks = 10;
        }
        return ticks;
      }

      // Moves a dragger to a specific score. Can also animate the move, but does not do so by default.
      moveTo($dragger, score, animate) {
        if (animate == null) { animate = false; }
        const target = this.getLeftFromScore(score);
        if (animate === true) {
          $dragger.animate({left: target}, 200, () => {
            return this.updateCollection();
          });
        } else {
          $dragger.css({left: target});
          this.updateCollection();
        }

        return this.updateLabel($dragger, target);
      }

      // Updates the tickes on the picker based on the current scale
      updateTicks() {
        this.ui.ticks.empty();
        const tickCount = this.getPossibleTickCount();
        const visibleTickCount = this.getTickCountForRange(tickCount);
        this.updateTickInc();
        let i = 1;
        return (() => {
          const result = [];
          while (i <= visibleTickCount) {
            const tickNumber = (tickCount / visibleTickCount) * i;
            const left = tickNumber * this.tickInc;
            const score = this.getScoreFromLeft(left);
            if (score !== this.model.get('high')) {
              const html = `<div style="left: ${left}px" class="mark"><span>${score}</span></div>`;
              this.ui.ticks.append(html);
            }
            result.push(i++);
          }
          return result;
        })();
      }

      isPrime(n) {
        if (_.isNaN(n) || !isFinite(n) || (n % 1) || (n < 2)) { return false; }
        if ((n % 2) === 0) { return n === 2; }
        if ((n % 3) === 0) { return n === 3; }
        const m = Math.sqrt(n);
        let i = 5;
        while (i <= m) {
          if ((n % i) === 0) { return false; }
          if ((n % (i + 2)) === 0) { return false; }
          i += 6;
        }
        return true;
      }

      // Calculates and sets the width of a tick on the range picker
      updateTickInc() {
        return this.tickInc = this.getRangePickerWidth() / this.getPossibleValueCount();
      }

      // Calculates the width of the range picker
      getRangePickerWidth() {
        let width;
        if (this.ui.rangePicker.is(':visible')) {
          width = this.ui.rangePicker.width();
        } else {
          width = this.fallBackWidth;
        }
        return width;
      }

      // Gets the number of possible values for the model
      getPossibleValueCount() {
        return this.model.get('high') - this.model.get('low');
      }

      getPossibleTickCount() {
        let valueCount = this.getPossibleValueCount();
        const isPrime = this.isPrime(valueCount) && (valueCount > 15);
        if (isPrime === true) {
          let i = valueCount;
          while (this.isPrime(i) === true) { i--; }
          valueCount = i;
        }
        return valueCount;
      }

      // Give a left position, it returns the corresponding integer value based on the current scale
      getScoreFromLeft(left) {
        let score;
        if (left === 0) {
          score = this.model.get('low');
        } else {
          const tickPosition = left / this.tickInc;
          score = Math.round(tickPosition + this.model.get('low'));
        }
        return score;
      }

      // Given a score integer, it returns the corresponding left position
      getLeftFromScore(score) {
        const adjustedScore = score - this.model.get('low');
        return adjustedScore * this.tickInc;
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
        newValues.push(this.model.get('low'));
        newValues.push(this.model.get('high'));
        newValues = _.uniq(newValues);

        const targetCount = this.collection.length + 1;
        newValues = _.filter(newValues, value => {
          return (value <= this.model.get('high')) && (value >= this.model.get('low'));
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
      updateCollection() {
        if (this.collection.length > 0) {
          const values = this.getValues();
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
          return _.each(updates, (update, index) => {
            const range = this.collection.at(index);
            if (range != null) {
              return range.set(update);
            }
          });
        }
      }

      // Returns the values based on handle positions
      getValues() {
        let values = [];
        _.each(this.handles, handle => {
          const $handle = $(handle);
          const { left } = $handle.position();
          const score = this.getScoreFromLeft(left);
          return values.push(score);
        });
        values = _.sortBy(values, value => parseInt(value));
        return values;
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

      // Sets up the range picker UI
      initializeUi() {
        this.handles = [];

        // Setup ticks
        this.updateTicks();

        let values = this.getValuesFromCollection(this.collection);
        values = this.fixValues(values);

        this.ui.draggableContainer.empty();
        _.each(values, (value, index) => {
          const $handle = $('<div style="position: absolute" class="dragger" data-handle data-behavior="draggable"><span class="dragger-score"></span><div class="dragger-label"></div></div>');
          this.ui.draggableContainer.append($handle);
          this.moveTo($handle, value);
          this.handles.push($handle);
          if ((index !== 0) && ((index + 1) !== values.length)) {
            let startPosition = 0;
            return $handle.draggable({
              axis: "x",
              containment: "parent",
              drag: (event, ui) => {
                return this.handlePositionChange(ui);
              },
              start: (event, ui) => {
                _.each(this.handles, $dragger => {
                  return $dragger.removeClass('dragger-active');
                });
                ui.helper.addClass('dragger-active');
                return startPosition = ui.helper.position();
              },
              stop: (event, ui) => {
                this.snapToTick(ui.helper, startPosition.left);
                this.updateCollection();
                return this.updatePicker();
              }
            });
          } else {
            if (index === 0) {
              return $handle.addClass('dragger-locked dragger-low');
            } else {
              return $handle.addClass('dragger-locked dragger-high');
            }
          }
        });
        return this.updateCollection();
      }

      updatePicker() {
        this.render();
        return this.initializeUi();
      }

      initialize(options) {
        this.vent = options.vent;
        this.model = options.model;

        this.listenTo(this.model, 'change:low change change:high', () => {
          return this.updatePicker();
        });

        return this.listenTo(this, 'modal:after:show', function() {
          if (_.isObject(this.ui.rangePicker)) {
            return this.initializeUi();
          }
        });
      }
    };
    RangePickerModalView.initClass();
    return RangePickerModalView;
  })();
});

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}