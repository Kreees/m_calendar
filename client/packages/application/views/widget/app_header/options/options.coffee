m.WidgetView.extend {
  events: {
    "vmousedown img": "home"
  }
  "home": (e)->
    e.preventDefault()
    e.stopPropagation()
    return if m.router.path() == "/calendar"
    m.router.navigate("/calendar")

}