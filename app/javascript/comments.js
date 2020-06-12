$(document).on('turbolinks:load', function() {
  $('#question').on('click', '.add-comment-link', function(e) {
    e.preventDefault();

    var commentableId = $(this).data('commentableId');
    var commentableType = $(this).data('commentableType');

    $(this).hide();
    $(`#add-comment-${commentableType}-${commentableId}`).show();
  })

  $('form.add-comment-form').on('ajax:error', function(e) {
    var errors = e.detail[0]
    var errorsHtml = ""

    $.each(errors, function(index, value) {
      errorsHtml += (`<p>${value}</p`);
    })

    $('.comment-errors').html(errorsHtml)
  })
});
