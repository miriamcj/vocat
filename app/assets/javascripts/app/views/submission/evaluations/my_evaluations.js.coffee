define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/my_evaluations')
  ScoreSlider = require('views/submission/evaluations/score_slider')
  ExpandableRange = require('behaviors/expandable_range')
  ScoreCollection = require('collections/score_collection')
  ModalConfirmView = require('views/modal/modal_confirm')

  class MyEvaluations extends Marionette.CompositeView

    tagName: 'ul'
    template: template
    className: 'evaluation-collections evaluation-editable'
    childView: ScoreSlider

    ui: {
      utility: '[data-behavior="utility"]'
      subtotal: '[data-behavior="subtotal"]'
      total: '[data-behavior="total"]'
      publishButton: '[data-behavior="evaluation-publish"]'
      unpublishButton: '[data-behavior="evaluation-unpublish"]'
      destroyButton: '[data-behavior="evaluation-destroy"]'
      saveButton: '[data-behavior="evaluation-save"]'
      percentage: '[data-container="percentage"]'
      totalScore: '[data-container="total-score"]'
      subtotalScore: '[data-container="subtotal-score"]'

    }

    childViewOptions: () ->
      {
        vent: @
      }

    behaviors: {
      expandableRange: {
        behaviorClass: ExpandableRange
      }
    }

    triggers: {
      'click @ui.destroyButton': 'evaluation:destroy'
      'click @ui.publishButton': 'evaluation:publish'
      'click @ui.unpublishButton': 'evaluation:unpublish'
      'click @ui.saveButton': 'evaluation:save'
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
    }

    onEvaluationDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted evaluations cannot be recovered. Please confirm that you would like to delete your evaluation.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onEvaluationSave: () ->
      @vent.triggerMethod('evaluation:save')

    onConfirmDestroy: () ->
      @vent.triggerMethod('evaluation:destroy')

    onEvaluationPublish: () ->
      @model.set('published',true)
      @vent.triggerMethod('evaluation:dirty')
      @updatePublishedUnpublished()

    onEvaluationUnpublish: () ->
      @model.set('published',false)
      @vent.triggerMethod('evaluation:dirty')
      @updatePublishedUnpublished()

    updatePublishedUnpublished: () ->
      if @model.get('published') == true
        @ui.publishButton.hide()
        @ui.unpublishButton.show()
      else
        @ui.unpublishButton.hide()
        @ui.publishButton.show()

    updateCollectionFromModel: () ->
      if @model?
        @collection = @model.getScoresCollection()
      else
        @collection = new ScoreCollection()

    initialize: (options) ->
      @vent = options.vent
      @listenTo(@, 'childview:updated', () =>
        @vent.triggerMethod('evaluation:dirty')
        @updateTotals()
      )
      @updateCollectionFromModel()

    updateTotals: () ->
      console.log 'test'
      console.log @model.get('total_percentage_rounded')
      @ui.percentage.html(@model.get('total_percentage_rounded'))
      @ui.totalScore.html(@model.get('total_score'))
      @ui.subtotalScore.html(@model.get('total_score'))

    attachHtml: (collectionView, childView, index) ->
      if collectionView.isBuffering
        collectionView.elBuffer.appendChild(childView.el)
      else
        $(childView.el).insertBefore(collectionView.ui.subtotal)

    attachBuffer: (collectionView, buffer) ->
      $(buffer).insertBefore(collectionView.ui.subtotal)

    onRender: () ->
      @updatePublishedUnpublished()
