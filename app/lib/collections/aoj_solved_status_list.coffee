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
    "backbone"
    "app/models/aoj_solved_status"
    "com/backbone/backbone-localstorage"
  ]
  (
    Backbone
    AOJSolvedStatus
    _dummy_1
  )->
    class AOJSolvedStatusList extends Backbone.Collection
      model: AOJSolvedStatus
      initialize: (models, user_id)->
        @localStorage = new Backbone.LocalStorage("aoj-solved-status-#{user_id}")

      get_accepted: ->
        @where
          status: "Accepted"

      get_not_accepted: ->
        @filter (model)->
          model.get("status") != "Accepted"

      has_accepted: ->
        !! @findWhere
          status: "Accepted"
)
