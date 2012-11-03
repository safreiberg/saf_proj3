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