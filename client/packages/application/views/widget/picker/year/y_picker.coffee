muon.WidgetView.extend {
  template: "year_picker"
  rendered: ()->
    if not @context.val
      return
    @value = new Date().getFullYear();
    $(m).bind("projection_updated."+this.context.val,@render_value.bind(this))
    m.set_projection(this.context.val,@value);
  events: {
    "vclick button": "change_year"
  },
  render_value: ->
    @value = m.get_projection(this.context.val)
    @$(".value").text(@value)
  change_year: (ev)->
    if (ev.currentTarget.id == "next")
      @value++;
    else
      @value--
    m.set_projection(this.context.val,@value)
}