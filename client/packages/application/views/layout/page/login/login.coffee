muon.PageLayoutView.extend {
  events: {
    "keypress input": "try_login"
  },
  try_login: (ev)->
    if(ev.keyCode == 13)
      # TODO сделать логин в приложение
      m.user_logined = true;
      localStorage["user"] = @$("input.user").val();
      localStorage["password"] = @$("input.password").val();
      m.router.navigate("/calendar");
}