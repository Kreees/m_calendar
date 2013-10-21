muon.PageLayoutView.extend {
  init: ()->
    muon.set_projection("year_picker_var",{val:"year_picker_val"});
    muon.set_projection("month_picker_var",{val:"month_picker_val"});
    muon.set_projection("next",{force:"next"});
    muon.set_projection("prev",{force:"prev"});
}