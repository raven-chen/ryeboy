$("#myModal").on("shown.bs.modal", function(){
  $.ajax({
    url: Tao.Routes.readNotification,
    data: { "read_notification_at": "now" },
    type: 'PUT',
    error: function() {
      alert("发生内部错误,如多次出现此提示,请联系管理员");
    }
  });
});
