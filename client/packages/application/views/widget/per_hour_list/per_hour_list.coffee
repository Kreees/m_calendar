muon.WidgetView.extend {
  init: (context)->
    if !context.date
      context.date = new Date()
  events: {
    "click .add": "add_note"
    "click .hour": "toggle_hour_list"
    "click .empty .title": "add_note"
  },
  add_note: (ev)->
    d = @context.date
    return if !(@context.collection?)
    date = new Date(d.getFullYear(),d.getMonth(),d.getDate(),ev.currentTarget.id,0,0)
    m.set_projection("add_note_date",date)
    m.router.navigate("/add_note")
  rendered: ->
    @$(".per_hour").append("<hr/>")
    @context.collection.fetch().then(@render_items.bind(this))
    @listenTo(@context.collection,"sync",@render_items.bind(this))
  render_items: ->
    col = @context.collection
    if !col?
      return
    day = @context.date.getDate()
    month = @context.date.getMonth()
    year = @context.date.getFullYear()
    ((hour)=>
      el = @$(".hour_"+hour)
      h_models = @context.collection.models.filter((m)->
        if new Date(m.get("date")) >= new Date(year,month,day,hour)
          if new Date(m.get("date")) < new Date(year,month,day,hour+1)
            return true
          return false
      )
      h_models = new m.Collection(h_models)
      if h_models.length != 0
        h_models.set_comparator("-pub_date")
        text = "<div><a data-route='/note/"+h_models.models[0].id+"'>"+h_models.models[0].get("title")+"</a></div>"
        text += "<div class='more'> and "+(h_models.length-1)+" more</div>" if (h_models.length > 1)
        el.find("#"+hour).html(text)
        ((model)=>
          return if not model?
          return if el[0].querySelectorAll("a[data-route='/note/"+model.id+"']").length > 0
          el.find(".full_list").append($("<div />").html(
            "<span class='then'>then&nbsp;&nbsp;&nbsp;</span>"+"<a data-route='/note/"+model.id+"'>"+
            model.get("title")+"</a>"
          ))
        )(h_models.models[i]) for i in [1..h_models.length]
        el.removeClass("empty").addClass("not_empty")
      else
        el.addClass("empty").removeClass("not_empty")
    )(hour) for hour in [23..0]
    @$el.addClass("rendered")
  toggle_hour_list: (ev)->
    return true if ev.target.dataset.route
    @$(".selected").not(ev.currentTarget).removeClass("selected");
    @$(".selected").not(ev.currentTarget).removeClass("selected");
    $(ev.currentTarget).toggleClass("selected");
  remove: ->
    m.WidgetView.prototype.remove.call(this)
}