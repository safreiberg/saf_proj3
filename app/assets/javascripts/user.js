var z = 0;

var update_top = function() {
  console.log("update_top" + z)
  z = z + 1;
  var url = '/user/top/update';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      console.log(data);
      console.log(z);
      $("#top_table").html(data);
    }
  });
}

var m = 0;

var update_show = function() {
  console.log("update_show_posts" + m)
  m = m + 1;
  var pathArray = window.location.pathname.split( '/' );
  var url = '/user/show/'+ pathArray.slice(-1)[0] +'/updateposts';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      console.log(data);
      console.log(m);
      $("#posts").html(data);
    }
  });
  
  console.log("update_show_comments" + m)
  var pathArray = window.location.pathname.split( '/' );
  var url = '/user/show/'+ pathArray.slice(-1)[0] +'/updatecomments';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      console.log(data);
      console.log(m);
      $("#comments").html(data);
    }
  });
  
  console.log("update_show_stats" + m)
  var pathArray = window.location.pathname.split( '/' );
  var url = '/user/show/'+ pathArray.slice(-1)[0] +'/updatestats';
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      console.log(data);
      console.log(m);
      $("#stats").html(data);
    }
  });
}