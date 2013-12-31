describe "T004: AOJSolvedStatusList", ->
  before (done)->
    requirejs(
      [
        "app/collections/aoj_solved_status_list"
        "app/models/aoj_solved_status"
      ]
      (
        AOJSolvedStatusList
        AOJSolvedStatus
      )=>
        @AOJSolvedStatusList = AOJSolvedStatusList
        @AOJSolvedStatus = AOJSolvedStatus

        @list_1 = new @AOJSolvedStatusList([], "user01")
        @list_2 = new @AOJSolvedStatusList([], "user02")
        @list_3 = new @AOJSolvedStatusList([], "user03")

        # Example: 
        # <status>
        #   <run_id>594130</run_id>
        #   <user_id>sh19910711</user_id>
        #   <problem_id>10000</problem_id>
        #   <submission_date>1362759128692</submission_date>
        #   <submission_date_str>Sat Mar 09 01:12:08</submission_date_str>
        #   <status>Accepted</status>
        #   <language>Python</language>
        #   <cputime>1</cputime>
        #   <memory>4180</memory>
        #   <code_size>21</code_size>
        # </status>

        @list_1.create new @AOJSolvedStatus
          problem_id: "10000"
          run_id: 594130
          status: "Accepted"
          language: "Python"

        @list_1.create new @AOJSolvedStatus
          problem_id: "10001"
          run_id: 594131
          status: "WA: Presentation Error"
          language: "Python"

        @list_2.create new @AOJSolvedStatus
          problem_id: "10002"
          run_id: 594132
          status: "Accepted"
          language: "Python"

        @list_1.create new @AOJSolvedStatus
          problem_id: "10003"
          run_id: 594133
          status: "Accepted"
          language: "Python"

        @list_2.create new @AOJSolvedStatus
          problem_id: "10005"
          run_id: 594134
          status: "Wrong Answer"
          language: "Python"

        @list_3.create new @AOJSolvedStatus
          problem_id: "10006"
          run_id: 594134
          status: "Wrong Answer"
          language: "Python"

        done()
    )

  context "A001: #get_user_status", ->
    it "B001: hoge1", ->
      @list_1.length.should.equal 3

    it "B002: hoge2", ->
      @list_2.length.should.equal 2

  context "A002: #get_accepted", ->
    it "B001: hoge1", ->
      @list_1.get_accepted().length.should.equal 2

    it "B002: hoge2", ->
      @list_2.get_accepted().length.should.equal 1

  context "A003: #get_not_accepted", ->
    it "B001: hoge1", ->
      @list_1.get_not_accepted().length.should.equal 1

    it "B002: hoge2", ->
      @list_2.get_not_accepted().length.should.equal 1

  context "A004: #has_accepted", ->
    it "B001: hoge1", ->
      @list_1.has_accepted().should.equal true

    it "B002: hoge2", ->
      @list_2.has_accepted().should.equal true

    it "B003: hoge3", ->
      @list_3.has_accepted().should.equal false


