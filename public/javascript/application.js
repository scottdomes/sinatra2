$(document).ready(function() {

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  $(".new-song").click(function() {
    $("#new-song-form").height(50);
  });

  $("#close-new-song-form").click(function() {
    $("#new-song-form").height(0);
  });

});
