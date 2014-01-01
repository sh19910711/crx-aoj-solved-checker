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
