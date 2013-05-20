#= require_self
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers


window.Vocat = {
  Bootstrap: {
    Views: {}
    Collections: {}
    Models: {}
  }
  Instantiated: {
    Views: {}
    Collections: {}
  }
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Routes: window.Routes # Pick up the JS-Routes object from the global variable for convenience.
}