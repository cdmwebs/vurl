$(document).ready(function() {
  setup_lucky_tooltip();
  setup_bookmarklet_tooltip();
  set_focus_on_url_input();

	$("#infoBar").hide();
	$("#infoBar").css("position", "absolute");
  $(window).resize(info_position);
  $(window).scroll(info_position);
	info_position();
  $("#infoBar").slideDown(400);
  // Pause for effect
  $("#infoBar").animate({opacity: 1.0}, 3000);
  $("#infoBar").fadeOut(800);
  $("#infoBar").animate({opacity: 0}, 1000);
});

function set_focus_on_url_input() {
  $('#vurl_url').focus();
}

function setup_bookmarklet_tooltip() {
  $('#bookmarklet .help').simpletip({
    content: "Drag the 'Vurlify!' button to your toolbar to vurlify any page address while you're browsing",
    fixed: false
  });
}

function setup_lucky_tooltip() {
  $('.lucky_link').simpletip({
    content: "Click to view a random vurl from the archives!",
    fixed: false
  });
}

// For infoBar
function info_position() {
	var scrollPosition = $(window).scrollTop();
	$("#infoBar").css("top",scrollPosition +"px");
	$("#infoBar").css("left","0px");
	$("#infoBar").css("width",$(window).width());
}
