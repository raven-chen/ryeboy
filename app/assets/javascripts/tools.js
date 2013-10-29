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

  // $(".ckeditor").ckeditor(); already initialized by ckeditor gem
});
