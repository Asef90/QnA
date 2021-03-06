$(document).on('turbolinks:load', function() {
  $("#question").on('ajax:success', 'a.vote', function(e) {

    var responseObject = e.detail[0];

    var votesNumber = responseObject.number;
    var votableId = responseObject.id;
    var votableType = responseObject.type.toLowerCase();

    $(`#${votableType}-votes-number-${votableId}`).text(votesNumber);
  })
    .on('ajax:error', function(e) {
      var error = e.detail[0]

      $('.no-roots').text(error)
    })
});
