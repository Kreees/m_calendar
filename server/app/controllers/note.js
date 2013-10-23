var Q = require('q');
var _ = require('underscore');

module.exports = m.rest.extend({
    dependencies: ["MUON:user.user"],
    where: function(){
        return {user:this.user.id};
    },
    actions: {
        create: function(req,res){
            req.body.user = this.user.id;
            return m.rest.actions.create.apply(this,arguments);
        },
        search: function(req,res){
            var _this = this;
            if (!isFinite(req.query.y) || !isFinite(req.query.m) || !isFinite(req.query.d)) return [];
            for(var i in req.query) req.query[i] = parseInt(req.query[i])
            var start = new Date(req.query.y,req.query.m,req.query.d);
            var end = new Date(req.query.y,req.query.m,req.query.d+1);
            return this.model.db.find({$and:[{"date":{$gte:start.toISOString(),$lt:end.toISOString()}},{user: _this.user.id}]});
        },
        next_prev: function(){
            var dfd = Q.defer();
            var model = this.model;
            var next = null, prev = null;
            var _this = this;
            model.db.get(this.value).then(_.partial(find,"$gt"),dfd.reject);
            function finish(){
                dfd.resolve({
                    prev: prev,
                    next: next
                });
            }
            function find(dir,n){
                var obj = {}; obj[dir] = n.get("pub_date");
                model.db.find({"$and":[{"date":n.get("date")},{"pub_date":obj},{user: _this.user.id}]})
                    .sort({pub_date: (dir=="$gt"?1:-1)}).limit(1).then(function(qs){
                        if (qs[0]) {
                            if (dir == "$gt"){
                                next = qs[0].toString();
                                find("$lt",n);
                            }
                            else {
                                prev = qs[0].toString();
                                finish()
                            }
                            return;
                        }
                        var obj = {}; obj[dir] = n.get("date");
                        model.db.find({$and:[{"date":obj},{user: _this.user.id}]}).sort({date: (dir=="$gt"?1:-1)}).limit(1).then(function(qs){
                            if (dir == "$gt"){
                                qs[0] && (next = qs[0].toString());
                                find("$lt",n);
                            }
                            else {
                                qs[0] && (prev = qs[0].toString());
                                finish();
                            }
                        },dfd.reject);
                    },dfd.reject);
            }
            return dfd.promise;
        }
    }
})