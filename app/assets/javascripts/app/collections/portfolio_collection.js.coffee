define ['backbone', 'models/submission'], (Backbone, SubmissionModel) ->

  class PortfolioCollection extends Backbone.Collection

    model: SubmissionModel

    url: (options = {}) ->
      url = '/api/v1'
      segments = ['courses', 'projects', 'groups', 'users']
      _.each segments, (segment) ->
        url += "#{segment}/#{options[segment]}" if options[segment]? && options[segment] != null
      url += '/submissions'
