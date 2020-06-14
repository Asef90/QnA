import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({ channel: "CommentsChannel",
                                  question_id: $('#question').attr('data-question-id') }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {


      this.appendComment(data.comment)
    },

    appendComment(comment) {
      var commentableType = comment.commentable_type.toLowerCase();
      var commentableId = comment.commentable_id
      var body = $('<p/>').addClass('comment').attr('id', `comment-${comment.id}`).text(`${comment.body}`)


      $('.comment-errors').html("");
      $(`#${commentableType}-comments-${commentableId}`).append(body);

      $(`textarea#comment-body-textarea-${commentableType}-${commentableId}`).val('');
      $(`form#add-comment-${commentableType}-${commentableId}`).hide();
      $('.add-comment-link').show();
    }
  });
});
