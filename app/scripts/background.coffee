requirejs(
  [
    "underscore"
    "app/notificator"
    "app/virtual_arena"
    "app/aoj_client"
    "app/alarm_receiver"
    "app/event_receiver"
    "app/context_menu"
    "app/page_action"
    "app/common"
    "app/utils"
    "app/models/setting"
  ]
  (
    _
    Notificator
    VirtualArena
    AOJClient
    AlarmReceiver
    EventReceiver
    ContextMenu
    PageAction
    Common
    Utils
    Setting
  )->
    # エントリポイント
    start = ->
      # AOJ Client
      aoj_client = new AOJClient "http://judge.u-aizu.ac.jp/onlinejudge/"

      # VirtualArenaのコンテストリストの取得
      virtual_arena = new VirtualArena("http://rhodon.u-aizu.ac.jp:8080/arena/")
      virtual_arena.update_contest_list().done ->
        virtual_arena.set_notificators()

      # chrome.alarmのレシーバーを開始する
      alarm_receiver = new AlarmReceiver(virtual_arena)

      # 各種イベントのレシーバーを開始する
      event_receiver = new EventReceiver(virtual_arena)

      # 問題ページを開いたとき（もしくは更新時）
      event_receiver.on "open-aoj-problem-page", (tab)=>
        setting.fetch().done ->
          # Solved Statusのリストを更新する
          problem_id = tab.url.match(/description.jsp?.*id=([0-9A-Za-z]*)/)[1]
          user_id = setting.get("aoj_user_id")
          PageAction.show tab, user_id, problem_id
          if ( user_id != "" )
            aoj_client.update_user_status(user_id, problem_id).done ->
              PageAction.show tab, user_id, problem_id

      # Context Menu
      context_menu = new ContextMenu(event_receiver)

      # コンテストリストを定期的に更新する
      chrome.alarms.create(
        "update-virtual-arena-contests"
        {
          # 15分間隔で更新
          periodInMinutes: 15
        }
      )

      @

    setting = new Setting
    setting.fetch().done(start).fail ->
      setting.save().done(start)

    @
)
