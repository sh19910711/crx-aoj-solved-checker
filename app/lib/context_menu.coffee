#
# The MIT License (MIT)
# 
# Copyright (c) 2012-2014 Hiroyuki Sano
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
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
