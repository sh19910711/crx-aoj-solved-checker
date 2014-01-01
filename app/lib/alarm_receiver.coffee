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
    "moment"
    "app/utils"
    "com/sprintf"
  ]
  (
    moment
    Utils
    sprintf
  )->
    class AlarmReceiver
      constructor: (virtual_arena)->
        @virtual_arena = virtual_arena
        chrome.alarms.onAlarm.addListener @on_alarm

      # alarm発火時のイベント
      on_alarm: (alarm)=>
        # コンテストリストの更新
        if alarm.name == "update-virtual-arena-contests"
          @virtual_arena.update_contest_list().done =>
            @virtual_arena.set_notificators()

        # VirtualArenaのコンテスト通知
        else if /^va-contest-/.test alarm.name
          @on_virtual_arena_contest_start(alarm)

      on_virtual_arena_contest_start: (alarm)=>
        # 情報を取得
        matches    = alarm.name.match(/va-contest-(.*)-(.*)/)
        contest_id = matches[1]
        start_in   = parseInt(matches[2], 10)
        contest    = @virtual_arena.contests.get(contest_id)

        date_format = "MM/DD HH:mm"
        start_date = new Date(parseInt(contest.get("start_date"), 10))
        start_date_text = moment(start_date).format(date_format)
        finish_date = new Date(parseInt(contest.get("finish_date"), 10))
        finish_date_text = moment(finish_date).format(date_format)
        message = "#{Utils.get_relative_time(start_in)} - \"#{contest.get("title")}\": #{start_date_text} - #{finish_date_text}"

        # 通知を表示
        chrome.notifications.create(
          alarm.name
          {
            type: "basic"
            iconUrl: "/images/icon-128.png"
            title: "Virtual Arena Contest Notification"
            message: message
          }
          ->
        )

        # クリックするとページを開いて閉じる
        # -> event_receiver
      
        # 指定時間で消す
        setTimeout(
          ->
            chrome.notifications.clear(
              alarm.name
              ->
            )
          9 * 1000
        )
)
