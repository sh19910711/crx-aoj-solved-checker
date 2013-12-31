define(
  [
    "backbone"
    "com/backbone/backbone-localstorage"
  ]
  (
    Backbone
    _dummy_1
  )->
    class Setting extends Backbone.Model
      localStorage: new Backbone.LocalStorage("setting")
      defaults:
        id: "config"
        aoj_user_id: ""
      initialize: ->
        @
)
