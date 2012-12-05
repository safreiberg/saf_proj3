// Called as a short poll to update the "top users" page.
var update_top = function() {
  var url = '/user/top/update';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      $("#top_table").html(data);
    }
  });
}

// Called as a short poll to update the "show user" page.
// Three different things need to be rendered here:
//   1) The posts that a user has made.
//   2) The comments that a user has made.
//   3) The statistics about the given user (karma, etc.)
var update_show = function() {
  var pathArray = window.location.pathname.split( '/' );
  // Posts
  var url = '/user/show/'+ pathArray.slice(-1)[0] +'/updateposts';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      $("#posts").html(data);
    }
  });
  // Comments
  url = '/user/show/'+ pathArray.slice(-1)[0] +'/updatecomments';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      $("#comments").html(data);
    }
  });
  // Stats
  url = '/user/show/'+ pathArray.slice(-1)[0] +'/updatestats';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      $("#stats").html(data);
    }
  });
}