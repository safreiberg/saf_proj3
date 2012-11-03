var x = 0;
  
var update = function() {
  console.log("update" + x)
  x = x + 1;
  $.ajax({
    type: 'GET',
    url: '/posts/update',
    success: function(data) {
      console.log(data);
      console.log(x);
      $("#posttable").html(data);
    }
  });
};

var y = 0;

var update_comments = function() {
  console.log("update_comments" + y)
  y = y + 1;
  var pathArray = window.location.pathname.split( '/' );
  var url = '/posts/update_comments/' + pathArray.slice(-1)[0];
  $.ajax({
    type: 'GET',
    url: url,
    success: function(data) {
      console.log(data);
      console.log(y);
      $("#commentstable").html(data);
    }
  });
};

