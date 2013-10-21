m.ApplicationStackView.extend {
  target: "target",
  rendered: ->
      if m.__static_app__
        @$el.width($(window).width()).height($(window).height()).css({top:0,left:0,margin:0});

}