module.exports = {
    url: "notes",
    attrs: {
        user: {
            type: "MUON:user.user"
        },
        title: {
            type: "string",
            default: ""
        },
        body: {
            type: "string",
            default: ""
        },
        date: {
            type: "date",
            default: new Date()
        }
    }
};