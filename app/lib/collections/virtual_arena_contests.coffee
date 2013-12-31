define(
  [
    "backbone"
    "app/models/virtual_arena_contest"
    "com/backbone/backbone-localstorage"
  ]
  (
    Backbone
    VirtualArenaContest
    _dummy_1
  )->
    class VirtualArenaContests extends Backbone.Collection
      model: VirtualArenaContest
      localStorage: new Backbone.LocalStorage("virtual-arena-contests")
      initialize: ->
        @

      # Acceptedなコンテストの取得
      get_accepted_contests: ->
        new VirtualArenaContests @filter (contest)->
          contest.get("state") == "Accepted"

      # 指定時刻から指定した時間以内に開催されるコンテストの取得
      get_upcoming_contests: (start_time, len)->
        start_time = new Date(start_time)
        end_time = new Date(start_time)
        end_time.setTime(end_time.getTime() + len * 60 * 1000)
        new VirtualArenaContests @filter (contest)->
          start_date = new Date(contest.get("start_date"))
          start_time <= start_date && start_date <= end_time
          
)
