muon.WidgetView.extend {
  events: {
    "keypress input": "try_login"
    "vclick .login": "try_login"
    "vclick .skip": "skip"
    "vclick .create": "create"
  },
  rendered: ->
    @$("input").on("focus",=>
      @$(".errors").text("")
    )
  try_login: (ev)->
    _this = this;
    delete localStorage["login"]
    delete localStorage["password"]
    ev.preventDefault() if ev.type == "vclick"
    if ev.keyCode == 13 or ev.type == "vclick"
      session = new m.models["MUON:user.session"]({
        login: _this.$("input.user").val()
        password: md5(_this.$("input.password").val())
        remember: true
      })
      session.save().then(->
        localStorage["login"] = _this.$("input.user").val()
        localStorage["password"] = _this.$("input.password").val()
        m.set_profile("logined")
        m.user_logined = true
      ,->
        _this.$(".errors").text("Wrong user and/or password")
      )
  skip: (e)->
    delete localStorage["login"]
    delete localStorage["password"]
    e.preventDefault()
    @user = "m"+new Date().getTime()
    @password = md5("m_pass"+new Date().getTime()).substring(0,6)
    @create(e)
  create: (e)->
    _this = this
    delete localStorage["login"]
    delete localStorage["password"]
    user = @$("input.user").val()
    password = @$("input.password").val()
    user = @user if @user
    password = @password if @password
    flag = false
    @$("input").removeClass("wrong")
    flag = true if !password or !user
    @$("input.user").addClass("wrong") if !user
    @$("input.password").addClass("wrong") if !password
    return if flag
    user_m = new m.models["MUON:user.user"]({
      nick: user,
      password: password
    })
    user_m  .save().then(->
      session = new m.models["MUON:user.session"]({
        login: user
        password: md5(password)
        remember: true
      })
      session.save().then(->
        localStorage["login"] = user
        localStorage["password"] = md5(password)
        m.set_profile("logined")
      )
    ,(e)=>
      @$(".errors").text("Such user already exists")
    )
}