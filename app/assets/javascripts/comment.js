$(function(){
  $(".js-reply-to-comment a").click(function(){
    $("#comment_replied_comment_id").val($(this).data("comment-id"));
    $(".note-editable").attr("data-placeholder", $(this).data("reply-to"));
  });
});
