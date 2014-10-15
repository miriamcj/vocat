define ['backbone'], (Backbone) ->
  class EvaluationModel extends Backbone.Model

    paramRoot: 'evaluation'

    omitAttributes: ['total_points', 'total_percentage', 'total_percentage_rounded']
    urlRoot: "/api/v1/evaluations"

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


    initialize: () ->
      @on('change:scores', () =>
        @updateCalculatedScoreFields()
      )
      @updateCalculatedScoreFields()

    updateCalculatedScoreFields: () ->
      total = 0
      _.each(@.get('score_details'), (details, fieldKey) =>
        total = total + parseInt(details['score'])
      )

      per = parseFloat(total / parseInt(@get('points_possible'))) * 100
      @set('total_points', total)
      @set('total_percentage', per)
      @set('total_percentage_rounded', per.toFixed(0))
