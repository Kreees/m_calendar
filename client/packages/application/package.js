module.exports = {
    use_app_layout: true,
    pages: ["*"],
    models: ["*"],
    middleware: [
        function(){
            m.set_projection("back_app_header",{str: this.back_str || ""});
            m.set_projection("title_app_header",{});
        }
    ],
    routes: [
        {
            route: "",
            redirect: "/calendar"
        },
        {
            route: "logout",
            callback: function(){
                delete localStorage["user"];
                delete localStorage["password"];
                m.user_logined = false;
                _.defer(m.route,"/login");
            }
        },
        {
            route: "calendar",
            callback: function(){
                this.back_str = "Calendar";
            }
        },
        {
            route: "notes/:y/:m/:d",
            page: "day_view",
            callback: function(y,month,d){
                this.back_str = "Schedule";

                var projection = m.get_projection("notes_day_list");
                if (projection && projection.date.toString() == new Date(y,month,d).toString()){
                    projection.collection.fetch();
                }
                else {
                    var col = m.models.note.collection({d:d,m:month,y:y});
                    m.set_projection("notes_day_list",{
                        date: new Date(y,month,d),
                        collection: col
                    });
                }
            }
        },
        {
            route: "note/:id",
            page: "note_view",
            callback: function(id){
                this.back_str = "Note";
                var model = new m.models.note(id);
                model.fetch();
                m.set_projection("note_full_view",model);
            }
        },
        {route: "options"},
        {route: "add_note"}
    ],
    surrogate: {},
    ready: function(cb){
        _.defer(cb);
        this.back_str = [];
        m.monthes = ["January","February","March","April","May","June","Jule","August","September","October","November","December"]
        m.days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]


        if (localStorage["login"] && localStorage["password"]){
            m.user_logined = true;
            m.set_profile("logined");
            (new m.models["MUON:user.user"]("me")).fetch().fail(function(){
                m.remove_profile("logined");
            });
        }
        else {
            m.router.navigate("/",{skipHistory: true,trigger:false});
        }
    }
}