describe "T005: AOJClient", ->
  before (done)->
    requirejs(
      [
        "app/aoj_client"
      ]
      (
        AOJClient
      )=>
        @AOJClient = AOJClient

        # http://judge.u-aizu.ac.jp/onlinejudge/webservice/status_log?user_id=sh19910711&problem_id=10000&limit=10
        nock("http://judge.u-aizu.ac.jp")
          .filteringPath(/\?user_id=test.*/, "?user_id=test")
          .get("/onlinejudge/webservice/status_log?user_id=test")
          .reply 200, ->
            fs.readFileSync "./test/mock/t005-aoj-status-log.xml"

        done()
    )

  context "A001: #get_user_status", ->
    it "B001: test", (done)->
      client = new @AOJClient("http://judge.u-aizu.ac.jp/onlinejudge/")
      user_id = "test"
      problem_id = "10000"
      client.update_user_status(user_id, problem_id).done ->
        client.get_user_status(user_id, problem_id).done (list)->
          list.length.should.equal 10
          done()


