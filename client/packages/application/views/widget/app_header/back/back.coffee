flag = false
back_list = []

m.WidgetView.extend {
  init: ->
    @context.str = back_list.pop() || "" if flag
    flag = false
  events: {
    "vmousedown": "back"
  }
  rendered: ->
    if m.router.history().length < 1
      @$el.addClass("no-history")
    else
      @$el.removeClass("no-history")
  back: (ev)->
    ev.preventDefault()
    ev.stopPropagation()
    if m.router.history().length < 1
      return
    flag = true
    m.router.back();
  remove: ->
    if !flag
      back_list.push(@context.str)
    m.WidgetView.prototype.remove.call(this)
}