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
    "underscore"
    "app/utils"
  ]
  (
    _
    Utils
  )->
    class Notificator
      set_contest: (contest)->
        cur_time = new Date() / 1

        # alarmを発火するタイミングのリスト（分単位）
        # TODO: 設定で変更できるようにする
        lens = [
          0
          10
          180
          60 * 24
        ]
        _(lens).each (len)->
          # 既に過ぎているものは登録しない
          name = "va-contest-#{contest.get("id")}-#{len}"

          # n分前になったらアラームを発火
          # ID = va-contest-{contest-no}-{len}
          alarm_time = parseInt(contest.get("start_date") / 1, 10) - len * 60 * 1000
          if cur_time <= alarm_time
            chrome.alarms.create(
              name
              {
                when: alarm_time
              }
            )
)
