$(function(){
  $("#quick-search-conditions button.js-quick-date-select").click(function(){
    $("#from").val($(this).data("from"));
    $("#to").val($(this).data("to"));
    $("form").submit();
  });

  $("#quick-search-conditions button.js-order-select").click(function(){
    $("#order").val($(this).data("order"));
    $("form").submit();
  });

  $("#quick-search-conditions button.js-no-comment-select").click(function(){
    $("#no_comment").val(true);
    $("form").submit();
  });

  // Score exercise
  $(".js-rate-exercise").change(function(){
    var view = $(this);

    $.ajax({
      url: Ryeboy.Routes.rateExercise,
      data: { id: view.data("exercise-id"), score: view.val() },
      type: 'PATCH',
      dataType: 'json',
      context: view,
      success: function(data){
        $(this).parent().html(data);
      },
      error: function() {
        alert("未成功,请刷新重试或联系管理员");
      }
    });
  });

  // Like exercise
  $(".js-like-exercise").click(function(){
    var view = $(this);

    if (view.find("i").hasClass("liked")) {
      $.post(
        Ryeboy.Routes.disLikeExercises,
        { id: view.data("exercise-id") },

        function() {
          var icon = view.find("i");
          var counter = view.find(".counter");
          var oldCount = parseInt(counter.text());

          icon.removeClass("liked icon-heart").addClass("icon-heart-empty");
          counter.text(oldCount - 1);
        }
      ).fail(function() {
        alert("未成功");
      });
    } else {
      $.post(
        Ryeboy.Routes.likeExercises,
        { id: view.data("exercise-id") },

        function() {
          var icon = view.find("i");
          var counter = view.find(".counter");
          var oldCount = parseInt(counter.text());

          icon.removeClass("icon-heart-empty").addClass("liked icon-heart");
          counter.text(oldCount + 1);
        }
      ).fail(function() {
        alert("未成功");
      });
    }
  });
});
