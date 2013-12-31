describe "T003: VirtualArenaContests", ->
  before (done)->
    requirejs(
      [
        "app/collections/virtual_arena_contests"
      ]
      (
        VirtualArenaContests
      )=>
        @VirtualArenaContests = VirtualArenaContests
        @contests = new @VirtualArenaContests

        @contests.add
          no: "1"
          title: "test"
          coordinator: "test"
          start_date: new Date(2000, 1, 1) / 1
          finish_date: new Date(2000, 1, 1) / 1
          state: "Finish"

        @contests.add
          no: "2"
          title: "test"
          coordinator: "test"
          start_date: new Date(2000, 2, 28) / 1
          finish_date: new Date(2000, 2, 28) / 1
          state: "Canceled"

        @contests.add
          no: "3"
          title: "test"
          coordinator: "test"
          start_date: new Date(2000, 3, 1) / 1
          finish_date: new Date(2000, 3, 1) / 1
          state: "Finish"

        @contests.add
          no: "4"
          title: "test"
          coordinator: "test"
          start_date: new Date(2000, 5, 30) / 1
          finish_date: new Date(2000, 5, 30) / 1
          state: "Canceled"

        @contests.add
          no: "5"
          title: "test"
          coordinator: "test"
          start_date: new Date(2000, 6, 1) / 1
          finish_date: new Date(2000, 6, 1) / 1
          state: "Accepted"

        @contests.add
          no: "6"
          title: "test"
          coordinator: "test"
          start_date: new Date(2000, 6, 2) / 1
          finish_date: new Date(2000, 6, 2) / 1
          state: "Accepted"

        done()
    )

  context "A001: #get_accepted_contests", ->
    it "B001: Acceptedなコンテストだけを取得", ->
      @contests.get_accepted_contests().length.should.equal 2
      # もとのコレクションには影響を与えない
      @contests.length.should.equal 6

  context "A002: そのまま", ->
    it "B001: 6個分", ->
      @contests.length.should.equal 6

  context "A003: #get_upcoming_contests", ->
    it "B001: 指定時刻から15分以内に開始するコンテスト", ->
      d = new Date(2000, 6, 1)
      d.setTime(d.getTime() - 10 * 60 * 1000)
      @contests.get_upcoming_contests(d, 15).length.should.equal 1

    it "B002: 指定時刻から5日以内に開始するコンテスト", ->
      d = new Date(2000, 5, 29)
      @contests.get_upcoming_contests(d, 5 * 24 * 60).length.should.equal 3

    it "B003: 指定時刻から5日以内に開始するAcceptedなコンテスト", ->
      d = new Date(2000, 5, 29)
      @contests.get_accepted_contests().get_upcoming_contests(d, 5 * 24 * 60).length.should.equal 2

