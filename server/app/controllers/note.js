module.exports = m.rest.extend({
    actions: {
        search: function(req,res){
            if (!isFinite(req.query.y) || !isFinite(req.query.m) || !isFinite(req.query.d)) return [];
            for(var i in req.query) req.query[i] = parseInt(req.query[i])
            var start = new Date(req.query.y,req.query.m,req.query.d);
            var end = new Date(req.query.y,req.query.m,req.query.d+1);
            return this.model.db.find({"date":{$gte:start.toISOString(),$lt:end.toISOString()}});
        }
    }
})