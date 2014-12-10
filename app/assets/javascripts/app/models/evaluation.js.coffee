define (require) ->

  Bacbone = require('backbone')
  ScoreCollection = require('collections/score_collection')

  class EvaluationModel extends Backbone.Model

    paramRoot: 'evaluation'
    omitAttributes: ['total_points', 'total_percentage', 'total_percentage_rounded']
    urlRoot: "/api/v1/evaluations"

    takeSnapshot: () ->
      @_snapshotAttributes = _.clone @attributes
      @_snapshotAttributes.score_details = {}
      _.each(@attributes.score_details, (element, index) =>
         @_snapshotAttributes.score_details[index] = _.clone(element)
      )
      @_snapshotAttributes.scores = _.clone @attributes.scores

    revert: () ->
      if @_snapshotAttributes
        @set(@_snapshotAttributes, {})
        @takeSnapshot()
        @updateScoresCollection()
      @trigger('revert')

    # We put a wrapper method around Backbone.sync to prevent calculated attribtues from being
    # sent to the server on post.
    sync: (method, model, options) ->
      unless options.attrs?
        attributes = model.toJSON(options)
        _.each(attributes, (value, key) =>
          if _.indexOf(@omitAttributes, key) != -1
            delete attributes[key]
        )
        options.attrs = attributes
      Backbone.sync(method, model, options)

    updateScoreFromCollection: () ->
      scoreDetails = @get('score_details')
      scores = @get('scores')
      @scoreCollection.each (scoreModel) =>
        key = scoreModel.id
        scores[key] = scoreModel.get('score')
        scoreDetails[key].score = scoreModel.get('score')
        scoreDetails[key].percentage = scoreModel.get('percentage')
      @set('score_details', scoreDetails)
      @set('scores', scores)
      @updateCalculatedScoreFields()

    initialize: () ->
      @takeSnapshot()
      @updateCalculatedScoreFields()
      @scoreCollection = new ScoreCollection()
      @updateScoresCollection()

      @listenTo(@,'sync', (e) =>
        @updateScoresCollection()
        @takeSnapshot()
      )

      @listenTo(@scoreCollection, 'change', (e) =>
        @updateScoreFromCollection()
      )

      @on('change:scores', () =>
        @updateCalculatedScoreFields()
      )

    updateCalculatedScoreFields: () ->
      total = 0
      _.each(@.get('score_details'), (details, fieldKey) =>
        total = total + parseInt(details['score'])
      )

      per = parseFloat(total / parseInt(@get('points_possible'))) * 100
      @set('total_score', total)
      @set('total_percentage', per)
      @set('total_percentage_rounded', per.toFixed(0))

    updateScoresCollection: () ->
      scores = @get('score_details')
      addScores = []
      _.each(scores, (score, key) ->
        addScore = _.clone(score)
        addScore.id = key
        addScores.push addScore
      )
      silent = true
      if @scoreCollection.length == 0 && addScores.length > 0
        silent = false
      else
        _.each(addScores, (score, index) =>
          model = @scoreCollection.get(score.id)
          if model? && model.score != score.score
            silent = false
        )
      @scoreCollection.reset(addScores, {silent: silent})

    scoreDetailsWithRubricDescriptions: (rubric) ->
      sd = @get('score_details')
      _.each(sd, (scoreDetail, property) ->
        range = rubric.getRangeForScore(scoreDetail.score)
        if range
          scoreDetail['desc'] = rubric.getCellDescription(property, range.id)
          scoreDetail['range'] = range.get('name')
          sd[property] = scoreDetail
      )
      sd

    getScoresCollection: () ->
      return @scoreCollection
