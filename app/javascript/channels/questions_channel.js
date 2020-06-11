import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('#questions-list').append(`<li><a href="/questions/${data.id}">${data.title}</a></li>`)
  }
});
