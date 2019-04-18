/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/project/detail/project_score_overview';

export default ProjectScoreOverview = (function() {
  ProjectScoreOverview = class ProjectScoreOverview extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.triggers = {
        'change @ui.viewToggle': {
          event: 'view:toggle',
          preventDefault: false,
          stopPropagation: false
        }
      };

      this.prototype.ui = {
        viewToggle: '[data-behavior="view-toggle"]'
      };
    }

    onViewToggle() {
      const val = this.$el.find('[data-behavior="view-toggle"]:checked').val();
      if (val === 'project-scores') {
        this.showProjectScores();
        return this.percentScoreOpacity('1');
      } else {
        this.showRubricScores();
        if (this.model.get('rubric_id')) {
          return this.percentScoreOpacity('1');
        } else {
          return this.percentScoreOpacity('0.4');
        }
      }
    }

    showProjectScores() {
      return this.updateCharts([this.model.get('instructor_average'), this.model.get('peer_average'), this.model.get('self_evaluation_average')]);
    }

    showRubricScores() {
      if (this.model.get('rubric_id')) {
        return this.updateCharts([this.model.get('rubric_instructor_average'), this.model.get('rubric_peer_average'), this.model.get('rubric_self_eval_average')]);
      } else {
        return this.updateCharts(['0', '0', '0']);
      }
    }

    updateCharts(values) {
      this.updateChart('.chartOne', values[0]);
      this.updateChart('.chartTwo', values[1]);
      return this.updateChart('.chartThree', values[2]);
    }

    updateChart(chartNum, percentage) {
      let background, foreground;
      const per = Math.floor(percentage * 100);
      const sliceOne = $(chartNum + ' .slice-one');
      const sliceTwo = $(chartNum + ' .slice-two');
      const percentScore = $(chartNum + ' .percent-score');

      switch (chartNum) {
        case '.chartOne':
          foreground = '#F6852E';
          background = '#FDE0CB';
          break;
        case '.chartTwo':
          foreground = '#866EC4';
          background = '#E1DBF0';
          break;
        case '.chartThree':
          foreground = '#3FC068';
          background = '#CFEFD9';
          break;
      }

      let base = background;
      const deg = ((per/100)*360);
      let deg1 = 90;
      let deg2 = deg;
      let color = foreground;
      if (per < 50) {
        color = background;
        base = foreground;
        deg1 = (((per/100)*360)+90);
        deg2 = 0;
      }

      sliceOne.css('transform', `rotate(${deg1}deg)`);
      sliceOne.css('-webkit-transform', `rotate(${deg1}deg)`);
      sliceOne.css('background', color);

      sliceTwo.css('transform', `rotate(${deg2}deg)`);
      sliceTwo.css('-webkit-transform', `rotate(${deg2}deg)`);
      sliceTwo.css('background', color);

      $(chartNum).css('background', base);

      return percentScore.text(Math.floor(percentage * 100) + '%');
    }

    percentScoreOpacity(percent) {
      return $('.percent-score').css('opacity', percent);
    }

    initialize(options) {
      this.options = options || {};
      return this.setupListeners();
    }

    setupListeners() {
      return this.listenTo(this.model, 'sync', () => this.render());
    }

    onRender() {
      return this.showProjectScores();
    }
  };
  ProjectScoreOverview.initClass();
  return ProjectScoreOverview;
})();