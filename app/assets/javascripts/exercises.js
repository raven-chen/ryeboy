$(function(){
  $("#quick-search-conditions button.js-quick-date-select").click(function(){
    $("#from").val($(this).data("from"));
    $("#to").val($(this).data("to"));
    $("form").submit();
  });

  $(".js-like-exercise").click(function(){
    var view = $(this);

    $.post(
      Tao.Routes.likeExercises,
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
  });
});
