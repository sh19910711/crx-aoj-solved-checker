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
    "app/collections/aoj_solved_status_list"
    "app/collections/cache_aoj_solved_status_list"
    "app/utils"
  ]
  (
    AOJSolvedStatusList
    CacheAOJSolvedStatusList
    Utils
  )->
    class AOJClient
      constructor: (base_url)->
        @base_url = base_url.replace /\/$/, ""

      get_user_status: Utils.get_deferred_func (deferred, user_id, problem_id)->
        status_list = new AOJSolvedStatusList([], user_id)
        status_list.fetch(
          success: ->
            deferred.resolve status_list.where(
              problem_id: problem_id
            )
          error: ->
            throw new Error "E003: fetch error"
        )
        @

      # 指定したユーザーの提出結果を取得する
      update_user_status: Utils.get_deferred_func (deferred, user_id, problem_id)->
        api_url = "#{@base_url}/webservice/status_log?user_id=#{user_id}&problem_id=#{problem_id}"
        $.get(api_url).done (res_body)=>
          # fetch成功時に呼ばれる
          fetch_success = ->
            # 
            root_element = $(res_body)
            if root_element.children("status_list").size()
              root_element = root_element.children("status_list")

            # キャッシュ用
            cache_status_list.create(
              id: problem_id
              last_fetch_count: root_element.children("status").size()
              is_accepted: _(root_element.children("status")).some (item)->
                /accepted/i.test $(item).children("status").text()
            )

            # 最初の50個を保存する
            status_list_raw = root_element.children("status").slice(0, 50).map ->
              {
                id: $.trim $(@).children("run_id").text()
                status: $.trim $(@).children("status").text()
                problem_id: $.trim $(@).children("problem_id").text()
                language: $.trim $(@).children("language").text()
              }
            _(status_list_raw).each (status)->
              status_list.create status

            deferred.resolve status_list.where(
              problem_id: problem_id
            )
          # 
          status_list = new AOJSolvedStatusList([], user_id)
          cache_status_list = new CacheAOJSolvedStatusList([], user_id)
          status_list.fetch().done ->
            cache_status_list.fetch().done ->
              fetch_success()
        @

)
