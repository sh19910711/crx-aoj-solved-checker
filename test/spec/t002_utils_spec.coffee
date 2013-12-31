describe "T002: Utils", ->
  before (done)->
    requirejs(
      [
        "app/utils"
      ]
      (
        Utils
      )=>
        @Utils = Utils
        done()
    )

  context "A001: #get_deferred_func", ->
    it "B001: Success", (done)->
      func = @Utils.get_deferred_func (deferred, arg)->
        deferred.resolve arg
      promise = func(1)
      promise.done (res)->
        res.should.equal 1
      promise.fail ->
        throw new Error "error"
      promise.always ->
        done()

    it "B002: Fail", (done)->
      func = @Utils.get_deferred_func (deferred, arg)->
        deferred.reject arg
      promise = func(1)
      promise.done ->
        throw new Error "error"
      promise.fail (res)->
        res.should.equal 1
      promise.always ->
        done()


  context "A002: #get_relative_time", ->
    it "B001: 0 minutes", ->
      @Utils.get_relative_time(0).should.equal "開催中"

    it "B002: 1 minutes", ->
      @Utils.get_relative_time(1).should.equal "1分後"

    it "B003: 59 minutes", ->
      @Utils.get_relative_time(59).should.equal "59分後"

    it "B004: 60 minutes", ->
      @Utils.get_relative_time(60).should.equal "1時間後"

    it "B005: 180 minutes", ->
      @Utils.get_relative_time(180).should.equal "3時間後"

    it "B006: 24 * 60 minutes", ->
      @Utils.get_relative_time(24 * 60).should.equal "1日後"

