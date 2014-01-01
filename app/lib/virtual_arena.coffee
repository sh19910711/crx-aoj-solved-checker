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
    "jquery"
    "app/utils"
    "app/collections/virtual_arena_contests"
    "app/notificator"
  ]
  (
    _
    $
    Utils
    VirtualArenaContests
    Notificator
  )->
    class VirtualArena
      constructor: (base_url)->
        @base_url = base_url.replace /\/$/, ""

      get_base_url: ->
        @base_url

      set_notificators: ->
        filtered_contest = @contests.get_accepted_contests().first(30)
        _(filtered_contest).each (contest)->
          notificator = new Notificator
          notificator.set_contest contest
        @

      # Virtual Arena のコンテストリストを取得する
      get_contest_list: Utils.get_deferred_func (deferred)->
        @contests = new VirtualArenaContests()
        @contests.fetch(
          success: =>
            deferred.resolve @contests
          error: ->
            throw new Error "E002: fetch error"
        )
        @

      # コンテストのリストを更新する
      update_contest_list: Utils.get_deferred_func (deferred)->
        self = @
        base_url = @base_url
        contest_list_url = "#{base_url}/webservice/contest_list?type=contest"

        # コンテストリストの取得
        $.get contest_list_url, (res_body)->
          # collectionのfetchが成功したときに呼ばれる
          fetch_success_func = ->
            # 最初の100個
            $("contest", res_body).slice(0, 100).map ->
              contest = $(@)
              keys = [
                "title"
                "coordinator"
                "start_date"
                "finish_date"
                "state"
              ]
              # VirtualArenaContestを生成
              contest_model = _(keys).reduce(
                (prev, key)->
                  obj = {}
                  obj[key] = $.trim contest.children(key).text()
                  _(prev).extend obj
                {
                  id: contest.children("no").text()
                  url: "#{base_url}/room.jsp?id=#{contest.children("no").text()}"
                }
              )
              self.contests.create contest_model

            deferred.resolve self.contests

          # collectionのfetchが失敗したときに呼ばれる
          fetch_error_func = ->
            throw new Error "E001: fetch error"

          # コレクションの取得
          self.contests = new VirtualArenaContests()
          self.contests.fetch(
            success: fetch_success_func
            error: fetch_error_func
          )
          @
        @
)
