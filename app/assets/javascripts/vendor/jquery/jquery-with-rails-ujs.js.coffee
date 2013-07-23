# app/assets/javascripts/jquery-with-rails-ujs.js.coffee

define ['jquery', 'jquery_ujs'], ($) ->

  # By depending on jQuery and Rails' built-in unobtrusive Javascript we
  # ensure that the jQuery object we return has Rails' customisations applied.
  return $