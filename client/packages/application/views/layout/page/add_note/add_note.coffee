m.PageLayoutView.extend {
  view_shown: ->
    m.set_projection("app_header_title",{str: "Add note"})
    model = new m.model_note({date: m.get_projection("add_note_date"),pub_date: new Date(),title: "",body: ""})
    m.set_projection("new_note",model)
}