
# 直前のタブを取っておく
last_tab = undefined
chrome.tabs.query(
  {
    active: true
    lastFocusedWindow: true
  }
  (tabs)->
    last_tab = tabs[0]
    start_requirejs()
)

start_requirejs = ->
  requirejs(
    [
      "jquery"
      "underscore"
      "app/models/setting"
      "app/aoj_client"
      "app/utils"
      "app/collections/cache_aoj_solved_status_list"
      "app/popup_layer"
      "com/jquery/jquery-ui"
    ]
    (
      $
      _
      Setting
      AOJClient
      Utils
      CacheAOJSolvedStatusList
      PopupLayer
      _dummy_1
    )->
      # ロック
      lock =
        info: false

      submissions = 0

      # 問題ID
      problem_id = Utils.get_problem_id_from_url(last_tab.url)

      # AOJ Client
      aoj_client = new AOJClient "http://judge.u-aizu.ac.jp/onlinejudge/"

      # manifest.json
      manifest = chrome.runtime.getManifest()

      # 設定
      setting = new Setting
      # 値が更新されたとき
      setting.on "sync", =>
        $("#aoj_user_id").text setting.get("aoj_user_id")
        $("#input_aoj_user_id").val setting.get("aoj_user_id")

      # レイヤーのアクションを設定
      _(PopupLayer.actions).extend
        "show-main": ->
          setting = new Setting
          setting.fetch().done ->
            Utils.set_info "loading..." unless lock.info
            lock.info = true
            user_id = setting.get "aoj_user_id"

            # AOJ キャッシュ
            cache_aoj_solved_status_list = new CacheAOJSolvedStatusList([], user_id)
            cache_aoj_solved_status_list.fetch().done ->
              deferreds = []
              cache_info = cache_aoj_solved_status_list.get(problem_id)
              last_fetch_count = if cache_info then cache_info.get("last_fetch_count") else undefined
              unless last_fetch_count != undefined && last_fetch_count >= 0
                deferreds.push aoj_client.update_user_status(user_id, problem_id)
              # get status
              $.when.apply(@, deferreds).done ->
                # ステータスリストを取得
                aoj_client.get_user_status(user_id, problem_id).done set_status_list

      # デフォルトメッセージを表示
      show_default = ->
        unless lock.info
          if submissions == 0
            Utils.set_info "No submissions"
          else
            Utils.set_info "閲覧する解答を選んでください"

      # Statusリストを表示する
      set_status_list = (list)->
        submissions = list.length
        status_list_element = $("#main ul.status-list")
        status_list_element.empty()
        _(list.slice(0, 36)).each (status)->
          status_list_element.append ->
            element = $("<li class='status #{Utils.get_status_class_name(status.get("status"))}'></li>")
            element.data "status", status.get("status")
            element.data "run_id", status.get("id")
            element.data "language", status.get("language")
            element
        lock.info = false
        show_default()

      # ユーザー名を確定して保存する
      confirm_aoj_user_id = =>
        $("#main ul.status-list").empty()
        user_id = $("#init input").val()
        setting.save(
          {
            aoj_user_id: user_id
          }
          {
            success: ->
              PopupLayer.show "main"
              Utils.refresh_all_page_actions()
          }
        )

      # DOMの初期化
      init_dom = =>
        # ユーザーIDを設定しているかどうかで最初に表示する画面を変更
        start_layer_name = if setting.get("aoj_user_id") == "" then "init" else "main"

        # ボタンを非表示にしておく
        $(".layer-button").hide()

        # レイヤーを表示する
        PopupLayer.show(start_layer_name, true)

        # ずらして表示
        $("#stage").find(".layer").each (x)->
          $(@).css
            left: "#{x * 100}%"

        # ステージをアニメーション表示
        $("#stage").animate(
          {
            opacity: 1.0
          }
          {
            duration: 125
            easing: "easeOutQuad"
          }
        )

        $("#stage_controller").animate(
          {
            opacity: 1.0
          }
          {
            duration: 125
            easing: "easeOutQuad"
          }
        )

        # フッターを設定
        $("#footer").html "Ver. #{manifest.version} - (c) 2012-2013 <a class='web-link' href='http://yomogimochi.com'>Hiroyuki Sano</span>"

      # イベントを設定する
      set_events = ->
        # リンクを開く
        $(document).on "click", "a.web-link", ->
          chrome.tabs.create
            url: $(@).attr("href")

        # 情報を表示する
        $(document).on "mouseover", ".status-list .status", ->
          Utils.set_info "##{$(@).data("run_id")}: #{$(@).data("status")}, #{$(@).data("language")}" unless lock.info

        # 情報を非表示にする
        $(document).on "mouseout", ".status-list .status", ->
          show_default()

        # 解答ページを開く
        $(document).on "click", ".status-list .status", ->
          chrome.tabs.create
            url: "http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=#{$(@).data("run_id")}"

        # 設定画面を開く
        $(document).on "click", ".layer-setting-button", ->
          chrome.tabs.create
            url: "/html/options.html"

        # 更新
        $(document).on "click", ".layer-update-button", ->
          Utils.set_info "loading..." unless lock.info
          lock.info = true
          $("#main .status-list").empty()
          user_id = setting.get "aoj_user_id"
          aoj_client.update_user_status(user_id, problem_id).done ->
            aoj_client.get_user_status(user_id, problem_id).done set_status_list

        # 説明の表示
        $(document).on "mouseover", ".layer-back-button", ->
          Utils.set_info "初期画面に戻ります" unless lock.info
        $(document).on "mouseover", ".layer-setting-button", ->
          Utils.set_info "設定画面を開きます" unless lock.info
        $(document).on "mouseover", ".layer-update-button", ->
          Utils.set_info "提出一覧を更新します" unless lock.info
        $(document).on "mouseout", ".layer-button", ->
          show_default()

        # レイヤーを一つ戻す
        $(document).on "click", ".layer-back-button", ->
          PopupLayer.show_back()

        # 初期設定画面のイベント
        $(document).on "click", "#init button", confirm_aoj_user_id
        $(document).on "keypress", "#init input", (e)->
          if e.keyCode == 13
            $(@).blur()
            confirm_aoj_user_id()

      # エントリポイント
      start = ->
        # イベントを設定する
        set_events()
        # HTMLの取得が終わってちょっと遅らせてから初期化
        $ ->
          setTimeout init_dom, 125

      setting.fetch().done(start).fail ->
        setting.save().done(start)
  )
