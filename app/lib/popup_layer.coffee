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
