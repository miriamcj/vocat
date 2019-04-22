/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';
import { clone, size } from "lodash";
import ScoreCollection from 'collections/score_collection';

export default class EvaluationModel extends Backbone.Model {
  constructor() {

    this.paramRoot = 'evaluation';
    this.omitAttributes = ['total_points', 'total_percentage', 'total_percentage_rounded'];
    this.urlRoot = "/api/v1/evaluations";
  }

  takeSnapshot() {
    this._snapshotAttributes = clone(this.attributes);
    this._snapshotAttributes.score_details = {};
    this.attributes.score_details.forEach((element, index) => {
      return this._snapshotAttributes.score_details[index] = clone(element);
    });
    return this._snapshotAttributes.scores = clone(this.attributes.scores);
  }

  revert() {
    if (this._snapshotAttributes) {
      this.set(this._snapshotAttributes, {});
      this.takeSnapshot();
      this.updateScoresCollection();
    }
    return this.trigger('revert');
  }

  // We put a wrapper method around Backbone.sync to prevent calculated attribtues from being
  // sent to the server on post.
  sync(method, model, options) {
    if (options.attrs == null) {
      const attributes = model.toJSON(options);
      attributes.forEach((value, key) => {
        if (this.omitAttributes.indexOf(key) !== -1) {
          return delete attributes[key];
        }
      });
      options.attrs = attributes;
    }
    return Backbone.sync(method, model, options);
  }

  updateScoreFromCollection() {
    const scoreDetails = this.get('score_details');
    const scores = this.get('scores');
    this.scoreCollection.each(scoreModel => {
      const key = scoreModel.id;
      scores[key] = scoreModel.get('score');
      scoreDetails[key].score = scoreModel.get('score');
      return scoreDetails[key].percentage = scoreModel.get('percentage');
    });
    this.set('score_details', scoreDetails);
    this.set('scores', scores);
    return this.updateCalculatedScoreFields();
  }

  initialize() {
    this.takeSnapshot();
    this.updateCalculatedScoreFields();
    this.scoreCollection = new ScoreCollection();
    this.updateScoresCollection();

    this.listenTo(this, 'sync', e => {
      return this.takeSnapshot();
    });

    this.listenTo(this, 'add', function() {
      return this.updateScoresCollection();
    });

    this.listenTo(this.scoreCollection, 'change', e => {
      return this.updateScoreFromCollection();
    });

    return this.on('change:scores', () => {
      return this.updateCalculatedScoreFields();
    });
  }

  updateCalculatedScoreFields() {
    let total = 0;
    this.get('score_details').forEach((details, fieldKey) => {
      return total = total + parseInt(details['score']);
    });

    const per = parseFloat(total / parseInt(this.get('points_possible'))) * 100;
    this.set('total_score', total);
    this.set('total_percentage', per);
    return this.set('total_percentage_rounded', per.toFixed(0));
  }

  updateScoresCollection() {
    const scores = this.get('score_details');
    const addScores = [];
    scores.forEach(function(score, key) {
      const addScore = clone(score);
      addScore.id = key;
      return addScores.push(addScore);
    });
    let silent = true;
    if ((this.scoreCollection.length === 0) && (addScores.length > 0)) {
      silent = false;
    } else {
      addScores.forEach((score, index) => {
        const model = this.scoreCollection.get(score.id);
        if ((model != null) && (model.score !== score.score)) {
          return silent = false;
        }
      });
    }
    return this.scoreCollection.reset(addScores, {silent});
  }

  scoreDetailsWithRubricDescriptions(rubric) {
    const sd = this.get('score_details');
    sd.forEach(function(scoreDetail, property) {
      const range = rubric.getRangeForScore(scoreDetail.score);
      if (range) {
        scoreDetail['desc'] = rubric.getCellDescription(property, range.id);
        scoreDetail['range'] = range.get('name');
        return sd[property] = scoreDetail;
      }
    });
    return sd;
  }


  validate(attrs, options) {
    const errors = {};
    if (attrs.score_details) {
      attrs.score_details.forEach(function(score, key) {
        if ((score.score < score.low) || (score.score > score.high)) {
          errors['score'] = [];
          return errors['score'].push(`contains an invalid value for field \"${score.name}\"--please adjust your score for this field and try again.`);
        }
      });
    }
    if (size(errors) > 0) { return errors; } else { return false; }
  }

  getScoresCollection() {
    return this.scoreCollection;
  }
}
