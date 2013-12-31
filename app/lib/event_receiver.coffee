define(
  [
    "backbone"
    "underscore"
    "app/utils"
    "app/page_action"
    "app/models/setting"
  ]
  (
    Backbone
    _
    Utils
    PageAction
    Setting
  )->
    regexp_aoj_problem_page = /^http:\/\/judge\.u-aizu\.ac\.jp\/onlinejudge\/description\.jsp/i
    setting = new Setting

    class EventReceiver
      _.extend @prototype, Backbone.Events

      constructor: (virtual_arena)->
        @virtual_arena = virtual_arena
        chrome.notifications.onClicked.addListener @notification_on_click
        chrome.contextMenus.onClicked.addListener @context_menu_on_click
        @set_tab_update()
        chrome.runtime.onMessage.addListener @on_message

      set_tab_update: =>
        chrome.tabs.onCreated.addListener (tab)=>
          if regexp_aoj_problem_page.test tab.url
            @trigger "open-aoj-problem-page", tab
        chrome.tabs.onUpdated.addListener (tabId, info, tab)=>
          if info.status == "loading"
            if regexp_aoj_problem_page.test tab.url
              @trigger "open-aoj-problem-page", tab

      # メッセージの送受信
      on_message: (req, sender, send_message)=>
        # 受信したデータをクリップボードにコピーする
        if req.type == "copy"
          Utils.copy_to_clipboard req.data
        # 指定されたユーザーのSolved Statusを更新
        else if req.type == "update-solved-status"
          # TODO
          user_id = req.user_id
        else if req.type == "refresh-all-page-actions"
          # TODO: 実装
          # 各タブについて
          # AOJの問題ページを開いているタブを探して
          # Page Actionを設定する
          setting.fetch().done ->
            chrome.tabs.query {}, (tabs)->
              _(tabs).each (tab)->
                if regexp_aoj_problem_page.test(tab.url)
                  PageAction.show tab, setting.get("aoj_user_id"), Utils.get_problem_id_from_url(tab.url)

      # コンテキストメニューがクリックされたときのイベント
      context_menu_on_click: (info, tab)=>
        if info.menuItemId == "copy_input"
          @trigger "copy-input", tab
        else if info.menuItemId == "copy_output"
          @trigger "copy-output", tab

      # 通知がクリックされたときのイベント
      notification_on_click: (notification_id)=>
        if /va-contest-/.test notification_id
          matches    = notification_id.match(/va-contest-(.*)-(.*)/)
          contest_no = matches[1]
          contest    = @virtual_arena.contests.get(contest_no)
          start_in   = matches[1]

          # 通知を消す
          chrome.notifications.clear(
            notification_id
            ->
          )

          # リンクを開く
          opened_url = contest.get("url")
          chrome.tabs.create
            url: opened_url
)
