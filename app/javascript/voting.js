$(document).on('turbolinks:load', function() {
  $("a.vote").on('ajax:success', function(e) {


    var votesNumber = e.detail[0].number;
    var votableId = e.detail[0].id;
    var votableType = e.detail[0].type.toLowerCase();

    $(`#${votableType}-votes-number-${votableId}`).text(votesNumber);
  })
    .on('ajax:error', function(e) {
      var error = e.detail[0]

      $('.no-roots').text(error)
    })
})
