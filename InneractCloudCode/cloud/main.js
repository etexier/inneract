
// Use Parse.Cloud.define to define as many cloud functions as you want.
Parse.Cloud.define("giveBadge", function(request, response) {
  var query = new Parse.Query("Badge");
  var currentUser = Parse.User.current();
  console.log('current user : ' + currentUser + ', currentUser id : ' + currentUser.id);
  query.equalTo("fromUserId", currentUser.id);
  query.equalTo("toUserId", request.params.toUserId);
  query.find({
    success: function(results) {
      if(results.length == 0) {
      	Parse.Cloud.useMasterKey();
		var query = new Parse.Query(Parse.User);
		query.get(request.params.toUserId, {
		  success: function(user) {
		    // The object was retrieved successfully.

			user.increment("badges");
			user.save();

		    var Badge = Parse.Object.extend("Badge");
			var badge = new Badge();
			badge.set("fromUserId", currentUser.id);
			badge.set("toUserId", request.params.toUserId);
			badge.save(null, {
			  success: function(badge) {
			    // Execute any logic that should take place after the object is saved.
			    alert('New badge created with objectId: ' + badge.id);
			    response.success("badge created");

			    //TODO send notification

			  },
			  error: function(badge, error) {
			    // Execute any logic that should take place if the save fails.
			    // error is a Parse.Error with an error code and message.
			    alert('Failed to create new object, with error code: ' + error.message);
			    console.log(error);
			    response.error(error);
			  }
			});
		  },
		  error: function(user, error) {
		  	console.log(error);
		  	response.error(error);
		    // The object was not retrieved successfully.
		    // error is a Parse.Error with an error code and message.
		  }
		});
  	  } else {
        response.error('User ' + user.username + ' has already given badge to ' + request.params.toUserId);
  	  }
    },
    error: function() {
		response.error("failed to lookup badge");
    }
  });
});
