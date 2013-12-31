define(
  [
    "backbone"
    "app/models/aoj_solved_status"
    "com/backbone/backbone-localstorage"
  ]
  (
    Backbone
    AOJSolvedStatus
    _dummy_1
  )->
    class AOJSolvedStatusList extends Backbone.Collection
      model: AOJSolvedStatus
      initialize: (models, user_id)->
        @localStorage = new Backbone.LocalStorage("aoj-solved-status-#{user_id}")

      get_accepted: ->
        @where
          status: "Accepted"

      get_not_accepted: ->
        @filter (model)->
          model.get("status") != "Accepted"

      has_accepted: ->
        !! @findWhere
          status: "Accepted"
)
