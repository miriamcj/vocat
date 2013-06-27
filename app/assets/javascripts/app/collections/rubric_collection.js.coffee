define ['backbone', 'models/rubric'], (Backbone, RubricModel) ->

  class RubricCollection extends Backbone.Collection
    model: RubricModel

