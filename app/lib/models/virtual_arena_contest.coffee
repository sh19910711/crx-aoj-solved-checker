define(
  [
    "backbone"
  ]
  (
    Backbone
  )->
    class VirtualArenaContest extends Backbone.Model
      defaults: ->
        no: ""
        title: ""
        coordinator: ""
        start_date: ""
        finish_date: ""
        state: ""

      initialize: ->
        @
)
