monthes = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

get_date = (d)->
  d = new Date(d)
  day = d.getDate().toString()
  day = "0"+day if day.length == 1
  month = (d.getMonth()+1).toString()
  month = "0"+month if month.length == 1
  year = (d.getFullYear()-2000).toString()

  return day+" "+monthes[d.getMonth()]+" "+year

days_diff = (a,b)->
  if b?
    b = new Date(b).getTime()
  else
    b = new Date().getTime()
  a = new Date(a).getTime()

  dif = b - a
  return Math.floor(dif/1000/60)

diff_str = (dif)->
  if dif < 0
    dif *= -1
  dif = Math.floor(dif)
  tail = "just now" if dif < 1
  tail = "1 minute" if dif == 1
  tail = Math.floor(dif) + " minutes" if dif > 1 and dif < 60
  tail = "1 hour" if dif >= 60 and dif < 119
  tail = Math.floor(dif/60) + " hours" if dif >= 120 and dif < 60*24
  tail = "1 day" if dif >= 60*24 and dif < 60*48
  tail = Math.floor(dif/60/24) + " days" if dif >= 60*48 and dif < 60*24*7
  tail = "1 week" if dif >= 60*24*7 and dif < 60*24*14
  tail = Math.floor(dif/60/24/7) + " weeks" if dif >= 60*24*14 and dif < 60*24*30
  tail = "1 month" if dif >= 60*24*30 and  dif < 60*24*61
  tail = Math.floor(dif/60/24/30) + " monthes" if dif >= 60*24*61 and dif < 60*24*365
  tail = "1 year" if dif >= 60*24*365 and dif < 60*24*730
  tail = Math.floor(dif/60/24/365) + " years" if dif >= 60*24*730
  return tail

m.ModelView.extend {
  rendered: ->
    @model.action("next_prev").then((obj)=>
      @$(".next_prev").addClass("prev") if obj.prev
      @$(".next_prev").addClass("next") if obj.next
      @prev = obj.prev
      @next = obj.next
    )
  events: {
    "vclick .next_prev div:first-child": "prev"
    "vclick .next_prev div:last-child": "next"
  }
  get_date: ->
    return get_date(@model.get("date"))
  get_date_dif: ->
    dif = days_diff(@model.get("date"))
    return diff_str(dif) + " left" if dif < 0
    return "now" if dif == 0
    return diff_str(dif) + " past" if dif > 0
  get_pub_date: ->
    return get_date(@model.get("pub_date"))
  get_pub_date_dif: ->
    dif = days_diff(@model.get("pub_date"))
    return diff_str(dif) + " ago"
  next: ->
    return if !@$(".next_prev").hasClass("next")
    m.router.navigate("/note/"+@next)
  prev: ->
    return if !@$(".next_prev").hasClass("prev")
    m.router.navigate("/note/"+@prev)
}