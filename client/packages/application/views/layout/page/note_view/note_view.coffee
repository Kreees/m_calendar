m.PageLayoutView.extend {
  view_shown: ->
    m.remove_projection("note_full_view")
  view_hidden: ->
    m.remove_projection("note_full_view")
}