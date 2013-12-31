define(
  [
    "app/utils"
    "app/collections/cache_aoj_solved_status_list"
  ]
  (
    Utils
    CacheAOJSolvedStatusList
  )->
    class PageAction
      # TODO: 色を設定できるようにする
      @icon_info:
        "unsubmitted":
          background: "rgba(0, 0, 0, 0.5)"
          color: "rgba(255, 255, 255, 1.0)"
          text: "-"
        "set-user-id":
          background: "rgba(255, 204, 0, 0.7)"
          color: "rgba(0, 0, 0, 1.0)"
          text: "!"
        "accepted":
          background: "rgba(102, 204, 0, 1)"
          color: "rgba(255, 255, 255, 1.0)"
          text: "✓"
        "not-accepted":
          background: "rgba(204, 0, 0, 0.3)"
          color: "rgba(255, 255, 255, 1.0)"
          text: "✗"

      # アイコンを設定する
      @set_icon: (tabId, type)->
        # 背景設定
        canvas = document.createElement("canvas")
        context = canvas.getContext("2d")
        context.fillStyle = @icon_info[type].background
        Utils.fill_round_rect(context, 0, 0, 16, 16, 2)

        # フォント設定
        context.font = "bold 14px"
        context.fillStyle = @icon_info[type].color
        metrix = context.measureText @icon_info[type].text

        # 中央寄せ
        leftPos = parseInt((16 - metrix.width) / 2)
        context.fillText @icon_info[type].text, leftPos, 12

        # Page Actionのアイコンに設定
        chrome.pageAction.setIcon
          tabId: tabId
          imageData: context.getImageData(0, 0, 16, 16)

      # 指定したタブに指定したユーザーのSolved Statusを表示
      @show: (tab, user_id, problem_id)->
        # タイトルを設定
        chrome.pageAction.setTitle
          tabId: tab.id
          title: "AOJ Solved Checker"

        # ユーザーIDが設定されていないとき
        unless user_id && user_id != ""
          PageAction.set_icon tab.id, "set-user-id"

        # Solved Status
        else
          # キャッシュの取得
          cache_aoj_solved_status_list = new CacheAOJSolvedStatusList [], user_id
          cache_aoj_solved_status_list.fetch().done ->
            cache_info = cache_aoj_solved_status_list.get(problem_id)
            # 解答ステータスを取得してアイコンを設定する
            status_class_name = "unsubmitted"
            if cache_info && cache_info.get("last_fetch_count") > 0
              if cache_info.get("is_accepted")
                status_class_name = "accepted"
              else
                status_class_name = "not-accepted"
            PageAction.set_icon tab.id, status_class_name
        chrome.pageAction.show tab.id
)
