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
            redirect: "/login"
        },
        {
            route: "login",
            callback: function(){
                if (m.user_logined) _.defer(m.router.navigate,"/calendar");
            }
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
                m.set_projection("note_full_view",new m.models.note(id))
            }
        },
        {
            route: "add_note"
        }
    ],
    surrogate: {},
    ready: function(cb){
        _.defer(cb);
        this.back_str = [];
        m.monthes = ["January","February","March","April","May","June","Jule","August","September","October","November","December"]
        m.days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        if (localStorage["user"] && localStorage["password"]) m.user_logined = true;
    }
}