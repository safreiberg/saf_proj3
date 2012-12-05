// Called as a short poll to update the posts on the
// post index page.
var update = function() {
  $.ajax({
    type: 'GET',
    url: '/posts/update',
    success: function(data) {
      // Put the formatted HTML into the proper
      // DIV element to display to the user.
      $("#posttable").html(data);
    }
  });
};

// Called as a short poll to update the comments on a 
// show post page.
var update_comments = function() {
  // Get the ID of the post that these comments
  // pertain to. This can be performed by looking in
  // the URL.
  var pathArray = window.location.pathname.split( '/' );
  var url = '/posts/update_comments/' + pathArray.slice(-1)[0];
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      // Put the formatted HTML into the proper
      // DIV element to display to the user.
      $("#commentstable").html(data);
    }
  });
};

