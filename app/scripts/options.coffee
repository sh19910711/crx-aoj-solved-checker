requirejs(
  [
    "app/models/setting"
    "app/utils"
  ]
  (
    Setting
    Utils
  )->
    # 情報を表示する
    set_info = (msg)->
      $("#info_text").text msg

    # 設定を保存する
    save_option = ->
      setting.save(
        aoj_user_id: $("#input_aoj_user_id").val()
      ).done ->
        Utils.refresh_all_page_actions()

    # エントリポイント
    start = ->
      $("#input_aoj_user_id").val setting.get("aoj_user_id")

      # 設定を保存する
      $(document).on "click", "#save_option", ->
        save_option().done ->
          set_info "設定を保存しました"
          setTimeout(
            ->
              set_info ""
            3000
          )

    # DOMを初期化する
    init_dom = ->
      $("#footer").html "Ver. #{manifest.version} - (c) 2012-2013 <a class='web-link' href='http://yomogimochi.com'>Hiroyuki Sano</span>"

    # manifest.json
    manifest = chrome.runtime.getManifest()

    setting = new Setting
    setting.fetch().done ->
      init_dom()
      start()
)
