m.WidgetView.extend {
  rendered: ->
    flag = true
    update = ()=>
      flag = !flag
      d = new Date()
      h = d.getHours().toString()
      h = "0"+h if h.length == 1
      m = d.getMinutes().toString()
      m = "0"+m if m.length == 1
      if flag
        m = ":"+m
      else
        m = " "+m
      @$("H4").text(h+m)
    @int = setInterval(update,1000);
    update()
  remove: ->
    clearInterval(@int)
    m.WidgetView.prototype.remove.call(this)
}