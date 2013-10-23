m.ApplicationStackView.extend {
  target: "target",
  init: ->
    fallback = (ev)->
      try
        return true if ev.target.tagName == "A" and ev.target.dataset.route
        ev.preventDefault()
      catch e
        ev.preventDefault()
    $(document).on("vclick",fallback)
  rendered: ->
      setTimeout(=>
        @$el.addClass("visible")
      , 100)
      if m.__static_app__
        @$el.width($(window).width()).height($(window).height()).css({top:0,left:0,margin:0});

}