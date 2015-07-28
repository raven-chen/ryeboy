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

  var $richEditor = $(".rich-editor");
  $richEditor.summernote({
    minHeight: 300,             // set minimum height of editor
    maxHeight: 900,             // set maximum height of editor
    lang: "zh-CN",
    focus: true,
    toolbar: [
      ['style', ['style']],
      ['font', ['bold', 'italic', 'underline', 'clear']],
      ['fontname', ['fontname']],
      ['color', ['color']],
      ['para', ['ul', 'ol', 'paragraph']],
      ['height', ['height']],
      ['table', ['table']],
      ['insert', ['link', 'video', 'picture', 'hr']],
      ['view', ['fullscreen', 'codeview']],
      ['help', ['help']]
    ],
    onImageUpload: function(files) {
      var image = new FormData();
      image.append("image[attachment]", files[0])

      $.ajax({
        url: Tao.Routes.uploadImage,
        data: image,
        processData: false,
        contentType: false,
        type: 'POST',
        success: function(data){
          var imgNode = $('<img>').attr('src', data.imageUrl);
          $richEditor.summernote('insertNode', imgNode[0]);
        },
        error: function(xhr) {
          alert(JSON.parse(xhr.responseText).error);
        }
      });
    }
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
