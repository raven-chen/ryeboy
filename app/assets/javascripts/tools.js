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

  $(".tab ul.tab-nav a").click(function() {
    $(this).tab("show");
  });

  $(".js-popover").popover({
    "placement" : "top",
    "trigger" : "hover"
  });

  $("#notification-switcher").click(function(){
    $("#notification-content").toggle();
  });

  $(".js-select2").select2();
  // $(".ckeditor").ckeditor(); already initialized by ckeditor gem
});
