
// Use Parse.Cloud.define to define as many cloud functions as you want.
Parse.Cloud.define("giveBadge", function(request, response) {
  var query = new Parse.Query("Badge");
  var currentUser = Parse.User.current();
  //console.log('current user : ' + currentUser + ', currentUser id : ' + currentUser.id);
  //console.log('current user details : ' + currentUser.get("firstName") + ' ' + currentUser.get("lastName"));
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
			    console.log('New badge created with objectId: ' + badge.id);
			    response.success("badge created");

			    // send notification
			    var notificationQuery = new Parse.Query(Parse.Installation);
+				notificationQuery.equalTo('userId', request.params.toUserId);
				Parse.Push.send({
				  where: notificationQuery, // Set our Installation query
				  data: {
				    alert: currentUser.get("firstName") + ' ' + currentUser.get("lastName") + ' gave you a badge.',
				    badge : "Increment",
				    t : "giveBadge",
				    userId : currentUser.id
				  }
				}, {
				  success: function() {
				    console.log('notification sent successfully');
				  },
				  error: function(error) {
				    alert('Failed to send notification to : ' + currentUser.username);
				  }
				});
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

Parse.Cloud.job("sendNewFeedNotification", function(request, status) {
	console.log("sendNewFeedNotification started");

	var feedQuery = new Parse.Query("IPNews");
	feedQuery.equalTo("isPushed", false);
	feedQuery.each(function(feed) {
		Parse.Push.send({
		  channels: [ "" ],
		  data: {
		    alert: 'A ' + feed.get("feedCategory") + ' "' + feed.get("title").substring(1, 72) + '" just published.',
		    badge : "Increment",
		    t : "newFeed",
		    fId : feed.id,
		    fc : feed.get("feedCategory")
		  }
		}, {
		  success: function() {
		    console.log('sendNewFeedNotification successfully for feed : ' + feed.id);
		  },
		  error: function(error) {
		    alert('Failed sendNewFeedNotification for feed : ' + feed.id);
		  }
		});

		feed.set("isPushed", true);
		feed.save(null, {
		  success: function(feedSaved) {
		    // Execute any logic that should take place after the object is saved.
		    console('updated isPushed of feed : ' + feed.id);
		  },
		  error: function(feedSaved, error) {
		    // Execute any logic that should take place if the save fails.
		    // error is a Parse.Error with an error code and message.
		    status.error('Failed to update isPushed of feed : ' + feed.id);
		  }
		});
    }).then(function() {
    		// Set the job's success status
    		status.success("sendNewFeedNotification completed successfully.");
		}, function(error) {
	    // Set the job's error status
	    status.error("Uh oh, something went wrong.");
	  });
});

// Parse.Cloud.afterSave("Activity", function(request, response) {
//   var activity = request.object;
// 	var currentUser = Parse.User.current();
// 	if(currentUser.id != 'e1feOLKy5B') {
// 		var notificationQuery = new Parse.Query(Parse.Installation);
// 		notificationQuery.equalTo('userId', 'e1feOLKy5B');
// 		Parse.Push.send({
// 		  where: notificationQuery, // Set our Installation query
// 		  data: {
// 		    alert: currentUser.get("firstName") + ' ' + currentUser.get("lastName") + ' ' + activity.get("action") + ' ' + activity.get("event").get("title"),
// 		    badge : "Increment",
// 		    t : "signUpEvent",
// 		    userId : currentUser.id
// 		  }
// 		}, {
// 		  success: function() {
// 		    console.log('notification sent successfully');
// 		  },
// 		  error: function(error) {
// 		    alert('Failed to send notification to : ' + currentUser.username);
// 		  }
// 		});
// 	}

//   response.success();
// });
