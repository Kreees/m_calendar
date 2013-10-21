muon.AddNoteModelView = muon.ModelView.extend {
  events: {
    "vmousedown #save": "save"
    "vmousedown .instrs > div": "instr"
    "vmousedown .colors > div": "color"
    "vmousedown .brush": "brush"
  }
  rendered: ->
    @$("input,textarea").one("change",=>
      @$("#save").removeClass("disabled");
    )
    @canvas = canvas = @el.getElementsByTagName("canvas")[0];
    @img = new Image
    pos = @$("#canvas").offset()
    w = @$("#canvas").outerWidth()
    h = @$("#canvas").outerHeight()
    @color_val = "rgba(0,0,0,1)"
    $(canvas).css({
      top: pos.top
      left: pos.left
      bottom: pos.top + w
      right: pos.left + h
      width: w
      height: h
    })
    canvas.width = w;
    canvas.height = h;
    @ctx = ctx = canvas.getContext("2d");
    flag = false
    totalOffsetX = canvas.offsetLeft - canvas.scrollLeft;
    totalOffsetY = canvas.offsetTop - canvas.scrollTop;
    currentElement = canvas;

    while currentElement = currentElement.offsetParent
      totalOffsetX += currentElement.offsetLeft - currentElement.scrollLeft
      totalOffsetY += currentElement.offsetTop - currentElement.scrollTop

    prev_c = null
    ctx.lineWidth = 2
    draw = (ev)=>
      return if !flag
      ev.preventDefault()
      e = ev
      c = {
        x: e.pageX - totalOffsetX
        y: e.pageY - totalOffsetY
      }

      if @eraser
        if prev_c
          dist = (prev_c.x - c.x)*(prev_c.x - c.x) + (prev_c.y - c.y)*(prev_c.y - c.y)
          dist = Math.floor(Math.sqrt(dist))
          cos = (prev_c.x - c.x)/dist
          sin = (prev_c.y - c.y)/dist
          ((e)->
            ctx.clearRect(prev_c.x-8+i*cos,prev_c.y-8+i*sin,16,16)
          )(i) for i in [0..dist]
        prev_c = c
        ctx.clearRect(c.x-8,c.y-8,16,16)
        return

      if prev_c
        ctx.beginPath()
        ctx.moveTo(prev_c.x,prev_c.y)
        ctx.lineTo(c.x,c.y)
        ctx.stroke()
      prev_c = c

      gd = ctx.createRadialGradient(c.x,c.y,0,c.x,c.y,ctx.lineWidth);
      gd.addColorStop(0,@color_val);
      gd.addColorStop(.7,@color_val.replace(",1)",",0)"));
      ctx.fillStyle = gd
      ctx.beginPath()
      ctx.arc(c.x,c.y,ctx.lineWidth,0,2*Math.PI);
      ctx.fill()
    $(canvas).on("vmousedown",->
      flag = true
    )
    $(canvas).on("vmouseup",->
      prev_c = null
      flag = false
    )
    $(canvas).on("vmousemove",draw)
  color: (e)->
    return if $(e.currentTarget).hasClass("selected")
    $(e.currentTarget).siblings().not(e.currentTarget).removeClass("selected")
    @ctx.strokeStyle = @ctx.fillStyle = @color_val = e.currentTarget.dataset.color
    $(e.currentTarget).addClass("selected")
  brush: (e)->
    el = e.currentTarget
    return if $(el).hasClass("selected")
    $(el).siblings().not(e.currentTarget).removeClass("selected")
    $(el).addClass("selected")
    if $(el).hasClass 'eraser'
      @eraser = true
      return
    @eraser = false
    @ctx.lineWidth = 2 if $(el).hasClass('small')
    @ctx.lineWidth = 4 if $(el).hasClass('medium')
    @ctx.lineWidth = 8 if $(el).hasClass('large')
  instr: (e)->
    el = e.currentTarget
    $(el).addClass("selected").siblings().removeClass("selected")
    if el.id == "text"
      @img.src = @canvas.toDataURL()
      @ctx.clearRect(0,0,@canvas.width,@canvas.height)
      @$("#canvas").css({
        "z-index":0
      })
      @$("#canvas .panel").hide()
    if el.id == "draw"
      @$("#canvas").css({
        "z-index":1
      })
      @$("#canvas .panel").show()
      setTimeout =>
        @ctx.drawImage(@img,0,0,@canvas.width,@canvas.height,0,0,@canvas.width,@canvas.height)
      ,1
  get_str_date: ->
    d = new Date(this.context.get("date"))
    return d.getDate()+"."+ (d.getMonth()+1)+"."+ (d.getFullYear()-2000)
  save: (e)->
    return if $(e.currentTarget).hasClass "disabled"
    @model.save().then ->
      m.router.back()
}
