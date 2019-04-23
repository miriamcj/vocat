/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { sortBy } from "lodash";

import AnnotationModel from 'models/annotation';

export default class AnnotationCollection extends Backbone.Collection {
  constructor() {
    this.model = AnnotationModel;
    this.assetHasDuration = false;

    this.url = '/api/v1/annotations';
  }

  initialize(models, options) {
    return this.assetHasDuration = Marionette.getOption(this, 'assetHasDuration');
  }

  comparator(annotation) {
    if (this.assetHasDuration) {
      return annotation.get('seconds_timecode') * -1;
    } else {
      return annotation.get('created_at_timestamp') * -1;
    }
  }

  getCurrentActive() {
    return this.find(model => model.get('active') === true);
  }

  lastActiveModelForSeconds(seconds) {
    if (this.length > 0) {
      let firstActive;
      const candidates = this.filter(annotation => annotation.get('seconds_timecode') <= seconds);
      const sortedCandidates = sortBy(candidates, annotation => annotation.get('seconds_timecode') * -1);
      return firstActive = sortedCandidates[0];
    }
  }

  deactivateAllModels(exceptForId = null) {
    return this.each(function(annotation) {
      if (exceptForId !== annotation.id) {
        return annotation.set('active', false);
      }
    });
  }

  activateModel(model) {
    this.deactivateAllModels(model.id);
    const currentState = model.get('active');
    if ((currentState === false) || (currentState == null)) {
      model.set('active', true);
      return this.trigger('model:activated');
    }
  }

  setActive(seconds) {
    const currentActive = this.getCurrentActive();
    const modelToActivate = this.lastActiveModelForSeconds(seconds);
    if (modelToActivate) {
      return this.activateModel(modelToActivate);
    } else {
      this.deactivateAllModels();
      return this.trigger('models:deactivated');
    }
  }
}

