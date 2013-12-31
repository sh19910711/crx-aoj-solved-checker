define(
  [
    "backbone"
  ]
  (
    Backbone
  )->
    class AOJSolvedStatus extends Backbone.Model
      defaults: ->
        problem_id: ""
        accepted: false
        status: ""
        language: ""

      initialize: ->
)
