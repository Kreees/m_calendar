daysInMonth = (year,month)->
  new Date(year, month+1, 0).getDate()

muon.WidgetView.extend {
  className: ""
  rendered: ()->
    $(m)
      .bind("projection_updated.year_picker_val",@period_changed.bind(this))
      .bind("projection_updated.month_picker_val",@period_changed.bind(this))
    _.defer(@period_changed.bind(this))
  events: {
    "click .day": "day_selected"
  },
  period_changed: ->
    month = m.get_projection("month_picker_val")
    year = m.get_projection("year_picker_val")
    offset = "0px"
    if @context.force?
      date = new Date(year,month,1)
      if @context.force == "next"
        date.setMonth(date.getMonth()+1)
      else
        date.setMonth(date.getMonth()-1)
      month = date.getMonth()
      year = date.getFullYear()
      if @context.force == "next"
        date.setMonth(date.getMonth()-1)
        if daysInMonth(date.getFullYear(),date.getMonth())+(date.getDay()+6)%7 < 35
          offset = "-64px"
      else
        if daysInMonth(year,month)+(date.getDay()+6)%7 < 35
          offset = "64px"
    @$(".days").css("margin-top",offset)
    @$(".days").children().remove();
    ((i)=>
      el = $("<div class='day'/>").text(i);
      if i == 1
        weekday = new Date(year,month,1).getDay()-1
        weekday = 6 if weekday == -1
        el.addClass("offset"+weekday)
      if [6,0].indexOf(new Date(year,month,i).getDay()) != -1
        el.addClass("weekend")
      el[0].dataset.day = i;
      el.appendTo(@$(".days"));
    )(i) for i in [1..daysInMonth(year,month)];
  day_selected: (ev)->
    year = m.get_projection("year_picker_val")
    month = m.get_projection("month_picker_val")
    day = ev.currentTarget.dataset.day
    m.router.navigate("/notes/"+ year+"/"+month+"/"+day)
}