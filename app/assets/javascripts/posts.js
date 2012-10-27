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
    
    
//    success: function(data) {
//      
//    }
//  });
