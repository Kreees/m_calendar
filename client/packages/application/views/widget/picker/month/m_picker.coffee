monthNames = [ "January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December" ];

muon.WidgetView.extend {
  rendered: ->
    if not @context.val
      return
    @value = new Date().getMonth();
    $(m).bind("projection_updated."+@context.val,@render_value.bind(this))
    m.set_projection(this.context.val,@value);
  events: {
    "vclick button": "change_value"
  }
  render_value: ->
    @value = m.get_projection(@context.val)
    @$(".value").text(monthNames[@value])
  change_value: (ev)->
    if (ev.currentTarget.id == "next")
      @value++;
    else
      @value--
    if @value > 11
      m.set_projection("year_picker_val",m.get_projection("year_picker_val")+1)
    if @value < 0
      m.set_projection("year_picker_val",m.get_projection("year_picker_val")-1)
      @value += 12
    m.set_projection(@context.val,@value % 12)

}