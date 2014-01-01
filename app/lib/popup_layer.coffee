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
  ]
  (
    _
  )->
    class PopupLayer
      # レイヤー名一覧
      layer_names = [
        "init"
        "main"
      ]

      # レイヤーの位置指定
      layer_offset = 0
      offset_to_name = {}
      name_to_offset = {}
      _(layer_names).each (layer_name, k)->
        offset_to_name[k] = layer_name
        name_to_offset[layer_name] = k

      # 各種イベント
      @actions: {}

      # 指定したレイヤーを表示する
      @show: (layer_name, no_animation = false)->
        # オフセットで指定されたときは変換する
        layer_name = offset_to_name[layer_name] if typeof layer_name == "number"
        layer_offset = name_to_offset[layer_name]
        action_name = $("##{layer_name}").data("action-after-show")
        @actions[action_name]() if @actions[action_name]? && @actions[action_name] instanceof Function

        # ボタン
        if layer_offset == 0
          $(".layer-back-button").hide(250)
          $(".layer-update-button").hide(250)
          $(".layer-setting-button").hide(250)
        else
          $(".layer-back-button").show(250)
          $(".layer-update-button").show(250)
          $(".layer-setting-button").show(250)

        # 表示
        css_opts = {
          left: "#{name_to_offset[layer_name] * -100}%"
        }
        if no_animation
          $("#stage").css css_opts
        else
          $("#stage").animate(
            css_opts
            {
              duration: 250
              easing: "easeOutQuad"
            }
          )

      # 戻る
      @show_back: ->
        @show(layer_offset - 1)
)
