describe "T001: VirtualArena", ->
  # モジュールを読み込む
  before (done)->
    requirejs(
      [
        "app/virtual_arena"
      ]
      (
        VirtualArena
      )=>
        @VirtualArena = VirtualArena
        @virtual_arena = new @VirtualArena("http://rhodon.u-aizu.ac.jp:8080/arena/")

        # mock http
        nock("http://www.google.co.jp")
          .get("/").reply 200, ->
            "test"

        nock("http://rhodon.u-aizu.ac.jp:8080")
          .filteringPath(/type=contest.*/, 'type=contest')
          .get("/arena/webservice/contest_list?type=contest")
          .reply 200, ->
            fs.readFileSync "./test/mock/t001-virtual-arena-contest-list.xml"

        done()
    )

  describe "A001: #get_contest_list", ->
    it "B001: コンテストの個数", (done)->
      @virtual_arena.get_contest_list().done (list)=>
        list.length.should.equal 0
        @virtual_arena.update_contest_list().done (list)=>
          list.length.should.equal 30
          done()

