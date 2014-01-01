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
    "jquery"
  ]
  (
    $
  )->
    class Utils
      # 関数をDeferred化
      @get_deferred_func: (func)->
        ->
          d = new $.Deferred
          args = Array.prototype.slice.call arguments
          args.unshift d
          func.apply this, args
          d.promise()

      @get_problem_id_from_url: (url)->
        url.match(/description.jsp?.*id=([0-9A-Za-z]*)/)[1]


      @refresh_all_page_actions: Utils.get_deferred_func (deferred)->
        chrome.runtime.sendMessage(
          {
            type: "refresh-all-page-actions"
          }
          deferred.resolve
        )
        @

      # 情報を表示する
      @set_info: (message)->
        $("#info_text").text message

      # コンテキストに丸い四角形を描画する
      @fill_round_rect: (context, left, top, width, height, radius)->
        context.beginPath()
        context.arc(left + radius, top + radius, radius, -Math.PI, -0.5 * Math.PI, false)
        context.arc(left + width - radius, top + radius, radius, -0.5 * Math.PI, 0, false)
        context.arc(left + width - radius, top + height - radius, radius, 0, 0.5 * Math.PI, false)
        context.arc(left + radius, top + height - radius, radius, 0.5 * Math.PI, Math.PI, false)
        context.closePath()
        context.fill()

      # ステータス名を分ける
      @get_status_class_name: (status)->
        return "status-accepted" if /accepted/i.test(status)
        return "status-wrong-answer" if /wrong/i.test(status) && /answer/i.test(status)
        return "status-wrong-answer" if /^wa:/i.test(status)
        return "status-error" if /error/i.test(status)
        return "status-error" if /limit/i.test(status) && /exceeded/i.test(status)
        ""

      # UUIDの取得
      @get_uuid: ()->
        s4 = ->
          (((1+Math.random())*0x10000)|0).toString(16).substring(1)
        "#{s4()}#{s4()}-#{s4()}-#{s4()}-#{s4()}-#{s4()}#{s4()}#{s4()}"

      # 相対的な時間を取得
      # 0 -> 開始
      # 1 -> 1分前
      # 60 -> 1時間前
      # 24*60 -> 1日前
      @get_relative_time: (minutes)->
        hours = Math.floor(minutes / 60)
        days = Math.floor(hours / 24)
        return "#{minutes}分後" if minutes > 0 && minutes < 60
        return "#{hours}時間後" if minutes >= 60 && minutes < 24 * 60
        return "#{days}日後" if minutes > 0
        return "開催中"

      # クリップボードにコピー
      @copy_to_clipboard: (data)->
        $("#clipboard_buffer").empty().text(data).select()
        document.execCommand "copy"
        $("#clipboard_buffer").empty()
)
