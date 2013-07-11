define [
  'marionette', 'hbs!templates/submission/score', 'collections/evaluation_collection', 'models/rubric', 'views/submission/score_item', 'views/submission/score_item_edit', 'views/submission/score_empty'
], (
  Marionette, template, EvaluationCollection, Rubric, ScoreItem, ScoreItemEdit, ScoreEmpty
) ->
  class EvaluationDetailScore extends Marionette.CompositeView

    template: template

    detailVisible: false

    itemView: ScoreItem

    getItemView: (item) ->
      if item.get('current_user_is_owner') == true
        ScoreItemEdit
      else
        ScoreItem

    itemViewOptions: () ->
      {
      rubric: @rubric
      }

    emptyView: ScoreEmpty
    itemViewContainer: '[data-behavior="scores-container"]'

    ui: {
      toggleDetailOn: '.js-toggle-detail-on'
      toggleDetailOff: '.js-toggle-detail-off'
    }

    triggers: {
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
    }

    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

      @collection = new EvaluationCollection([], {courseId: @courseId})
      @collection.fetch({
        data: {submission: @model.id}
      })

#    setDefaultViewState: () ->
#      if @detailVisible = true
#        @ui.toggleDetailOn.show()
#        @ui.toggleDetailOff.hide()
#      else
#        @ui.toggleDetailOn.hide()
#        @ui.toggleDetailOff.show()
#
#    onDetailToggle: () ->
#      if @detailVisible == true
#        # Hiding
#        @ui.toggleDetailOn.hide()
#        @ui.toggleDetailOff.show()
#        @detailVisible = false
#      else
#        # Showing
#        @ui.toggleDetailOn.show()
#        @ui.toggleDetailOff.hide()
#        @detailVisible = true
#
#
