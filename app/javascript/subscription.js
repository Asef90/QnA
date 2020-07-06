$(document).on('turbolinks:load', function() {
  $("#question").on('ajax:success', 'a.subscribe', function() {

    $(this).hide();
    $('a.unsubscribe').show();
  });

  $("#question").on('ajax:success', 'a.unsubscribe', function() {

    $(this).hide();
    $('a.subscribe').show();
  });
});
