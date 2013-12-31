define(
  [
  ]
  (
  )->
    # コンテキストメニュー関連の処理
    class ContextMenu
      constructor: (event_receiver)->
        @hide()
        @show()

        event_receiver.on "copy-input", (tab)=>
          chrome.tabs.executeScript(
            tab.id
            {
              file: "/scripts/aoj/copy_example_input.js"
            }
          )
        event_receiver.on "copy-output", (tab)=>
          chrome.tabs.executeScript(
            tab.id
            {
              file: "/scripts/aoj/copy_example_output.js"
            }
          )

      hide: ->
        chrome.contextMenus.removeAll()

      show: ->
        chrome.contextMenus.create(
          {
            type: "normal"
            contexts: [
              "page"
              "selection"
            ]
            title: "サンプル入力をコピーする"
            id: "copy_input"
            documentUrlPatterns: [
              "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=*"
            ]
          }
        )
        chrome.contextMenus.create(
          {
            type: "normal"
            contexts: [
              "page"
              "selection"
            ]
            title: "サンプル出力をコピーする"
            id: "copy_output"
            documentUrlPatterns: [
              "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=*"
            ]
          }
        )
)
