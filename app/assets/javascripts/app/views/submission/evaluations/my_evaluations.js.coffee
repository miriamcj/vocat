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
      destroyButton: '[data-behavior="evaluation-destroy"]'
      saveButton: '[data-behavior="evaluation-save"]'
      percentage: '[data-container="percentage"]'
      totalScore: '[data-container="total-score"]'
      subtotalScore: '[data-container="subtotal-score"]'
      childInsertBefore: '[data-anchor="child-insert-before"]'
      publishCheckbox: '[data-behavior="publish-switch"]'
      publishSwitch: '.switch'
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
      'click @ui.saveButton': 'evaluation:save'
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
      'click @ui.publishCheckbox': {
        event: 'evaluation:toggle'
        preventDefault: false
      }

    }

    onEvaluationDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted evaluations cannot be recovered.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onEvaluationSave: () ->
      @vent.triggerMethod('evaluation:save')

    onConfirmDestroy: () ->
      @vent.triggerMethod('evaluation:destroy')

    onEvaluationToggle: () ->
      state = @model.get('published')
      if state == true
        @model.set('published',false)
      else
        @model.set('published',true)
      @vent.triggerMethod('evaluation:dirty')
      @updatePublishedUIState()

    updatePublishedUIState: () ->
      if @model.get('published') == true
        @ui.publishSwitch.addClass('switch-checked')
        @ui.publishCheckbox.attr('checked', true)
      else
        @ui.publishSwitch.removeClass('switch-checked')
        @ui.publishCheckbox.attr('checked', false)

    updateCollectionFromModel: () ->
      if @model?
        @collection = @model.getScoresCollection()
      else
        @collection = new ScoreCollection()

    setupListeners: () ->
      @listenTo(@, 'childview:updated', () =>
        @vent.triggerMethod('evaluation:dirty')
        @updateTotals()
      )
      @listenTo(@model, 'change', () =>
        @updatePublishedUIState()
      )

    initialize: (options) ->
      @vent = options.vent
      @setupListeners()
      @updateCollectionFromModel()

    updateTotals: () ->
      @ui.percentage.html(@model.get('total_percentage_rounded'))
      @ui.totalScore.html(@model.get('total_score'))
      @ui.subtotalScore.html(@model.get('total_score'))

    attachHtml: (collectionView, childView, index) ->
      if collectionView.isBuffering
        collectionView.elBuffer.appendChild(childView.el)
      else
        $(childView.el).insertBefore(collectionView.ui.childInsertBefore)

    attachBuffer: (collectionView, buffer) ->
      $(buffer).insertBefore(collectionView.ui.childInsertBefore)

    onRender: () ->
      @updatePublishedUIState()
