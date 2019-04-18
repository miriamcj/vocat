/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'backbone', 'views/help/placard', 'hbs!templates/help/rubric_field_placard'
], function(Backbone, Placard, template) {
  let RubricFieldPlacard;
  return RubricFieldPlacard = (function() {
    RubricFieldPlacard = class RubricFieldPlacard extends Placard {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.className = 'placard';
        this.prototype.tagName = 'aside';
        this.prototype.attributes = {
          style: 'display: none'
        };
      }

      onInitialize() {
        this.rubric = this.options.rubric;
        this.fieldId = this.options.fieldId;
        this.options.showTest = () => {
          if (Vocat.glossaryEnabled === true) { return true; } else { return false; }
        };

        this.listenTo(this, 'before:show', data => this.onBeforeShow(data));
        return this.listenTo(Vocat.vent, `${this.options.key}:change`, data => {
          return this.showScoreDescription(data.score);
        });
      }

      showScoreDescription(score) {
        let showEl = null;
        const elements = this.$el.find('[data-low]');
        elements.each((index, el) => {
          const $el = $(el);
          const data = $el.data();
          if ((parseInt(data.low) <= score) && (parseInt(data.high) >= score)) {
            return showEl = $el;
          }
        });
        if (showEl == null) { showEl = elements.first(); }
        elements.hide();
        return showEl.show();
      }

      onBeforeShow(data) {
        if (this.visible === false) {
          const { score } = data.data;
          return this.showScoreDescription(score);
        }
      }

      serializeData() {
        const out = {
          fieldName: this.rubric.getFieldNameById(this.fieldId),
          fieldId: this.fieldId,
          descriptions: []
        };
        this.rubric.get('ranges').each(range => {
          return out.descriptions.push({
            rangeName: range.get('name'),
            rangeLow: range.get('low'),
            rangeHigh: range.get('high'),
            rangeId: range.id,
            rangeDescription: this.rubric.getCellDescription(this.fieldId, range.id)
          });
        });
        return out;
      }

      render() {
        return $('.page-content').prepend(this.$el.html(this.template(this.serializeData())));
      }
    };
    RubricFieldPlacard.initClass();
    return RubricFieldPlacard;
  })();
});
