$(function(){
  $(".js-submit-links a").click(function(){
    $("input[name='"+ $(this).data("target-name") +"']").val($(this).data("target-value"));
    $(this).closest("form").submit();
  });
});
