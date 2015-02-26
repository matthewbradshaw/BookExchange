var _ = require("underscore");
Parse.Cloud.beforeSave("Books", function(request, response) {
	var query = new Parse.Query("Books");
	query.equalTo("isbn10", request.object.get("isbn10"));
	query.equalTo("isbn13", request.object.get("isbn13"));
	query.first({
		success: function(obj) {
			if(obj) {
				response.error("Parse#saveBook :: [isbn10/isbn13] combination not unique");
			} else {
				var post = request.object;

			    var toLowerCase = function(w) { return w.toLowerCase(); };

			    var words = post.get("title").split(/\b/);
			    words = _.map(words, toLowerCase);
			    var stopWords = ["the", "in", "and"]
			    words = _.filter(words, function(w) { return w.match(/^\w+$/) && ! _.contains(stopWords, w); });


			    post.set("words", words);
				response.success();
			}
		},
		error: function() {
			response.error("Parse#saveBook :: failure unspecified error");
		}
	});
});
