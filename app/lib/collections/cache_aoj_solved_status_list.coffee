define(
  [
    "backbone"
    "app/models/cache_aoj_solved_status"
  ]
  (
    Backbone
    CacheAOJSolvedStatus
  )->
    class CacheAOJSolvedStatusList extends Backbone.Collection
      model: CacheAOJSolvedStatus
      initialize: (models, user_id)->
        @localStorage = new Backbone.LocalStorage("cache-aoj-solved-status-#{user_id}")

)
