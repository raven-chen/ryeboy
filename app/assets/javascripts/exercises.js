$(function(){
  $("#quick-search-conditions button.js-quick-date-select").click(function(){
    $("#from").val($(this).data("from"));
    $("#to").val($(this).data("to"));
    $("form").submit();
  });
});
