define ['backbone'], (Backbone) ->
  class EnrollmentModel extends Backbone.Model

    urlRoot: "/api/v1/enrollments"