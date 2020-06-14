$(document).on('turbolinks:load', function() {
  $('#question').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();

    var answerId = $(this).data('answerId');

    $(this).hide();
    $('form#edit-answer-' + answerId).show();
  })
});
