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
