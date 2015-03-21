$(function(){
  $(".js-date-field").datepicker({
    dateFormat: 'yy-mm-dd',
    changeYear: true,
    changeMonth: true,
    yearRange: "c-100:c+10",
    defaultDate: new Date(),
  });

  $("form.js-submit-on-change select, form.js-submit-on-change input[type='text']").change(function(){
    $("form.js-submit-on-change").submit();
  });

  $(".tab ul.nav-tabs a").click(function(e) {
    localStorage.setItem('lastTab', $(e.target).attr('href'));
  });

  lastTab = localStorage.getItem('lastTab');
  if (lastTab) {
    $(".tab ul.nav-tabs li").removeClass("active");
    $("a[href=" + lastTab + "]").parent().addClass("active");

    $(".tab-content div").removeClass("active");
    $("div#" + lastTab).addClass("active");
  }

  $("#notification-switcher").click(function(){
    $("#notification-content").toggle();
  });

  $(".js-select2").select2();

  $(".rich-editor").trumbowyg({
    lang: "zh_cn",
    autogrow: true
  });

  // Clean content inside editor
  $("#clean-editor").click(function(){
    $(".rich-editor").trumbowyg("html", new String);
  });

  $(".slider").unslider({
    dots: true
  });

  // Auto trigger review before 2015-1-1
  var newYear = new Date(2015,0,2);
  var today = new Date;
  if (today < newYear) {
    $("button#review").trigger("click");
  }
});
