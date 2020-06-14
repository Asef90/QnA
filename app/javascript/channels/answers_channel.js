import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({ channel: "AnswersChannel",
                                  question_id: $('#question').attr('data-question-id') }, {
    connected() {
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      var answerId = data.answer.id;

      if (gon.user_id != data.answer.author_id) {

        this.appendBody(answerId, data.answer.body);
        this.appendVotesCount(answerId);

        if (gon.user_id) {
          this.appendVoting(answerId);
        }

        this.appendLinks(answerId, data.links);
        this.appendFiles(answerId, data.files);

        if (gon.user_id === data.question_author_id) {
          this.appendSetBest(answerId);
        }
      }
    },

    appendBody(answerId, answerBody) {
      var body = $('<div/>').addClass('answer').attr('id', `answer-${answerId}`).text(`${answerBody}`)
      $('.answers').append(body)
    },

    appendVotesCount(answerId) {
      var votesCount = $('<p/>').attr('id', `answer-votes-number-${answerId}`).text('0')
      $(`#answer-${answerId}`).append(votesCount)
    },

    appendVoting(answerId) {
      var voteUp = $('<a/>').addClass('vote')
                            .attr({'data-remote':"true",
                                   'rel':"nofollow",
                                   'data-type':'json',
                                   'data-method':'post',
                                   'href':`/answers/${answerId}/vote_up`})
                            .text('+')
      var voteDown = $('<a/>').addClass('vote')
                              .attr({'data-remote':"true",
                                     'rel':"nofollow",
                                     'data-type':'json',
                                     'data-method':'post',
                                     'href':`/answers/${answerId}/vote_down`})
                              .text('-')
      $(`#answer-${answerId}`).append([voteUp, voteDown])
    },

    appendLinks(answerId, links) {
      var list = $('<ul/>');

      $.each(links, function(i) {
          var li = $('<li/>').attr('id', `answer-link-${links[i].id}`).appendTo(list);
          var a = $('<a/>').attr('href', `${links[i].url}`).text(`${links[i].name}`).appendTo(li);
      })

      $(`#answer-${answerId}`).append(list)
    },

    appendFiles(answerId, files) {
      $.each(files, function(i) {
        var p = $('<p/>').attr('id', `answer-file-${answerId}`).appendTo(`#answer-${answerId}`)
        var a = $('<a/>').attr('href', `${files[i].url}`).text(`${files[i].name}`).appendTo(p)
      })
    },

    appendSetBest(answerId) {
      var best = $('<a/>').addClass('set-best-answer')
                          .attr({'id':`set-best-answer-${answerId}`,
                                  'data-remote':"true",
                                  'rel':"nofollow",
                                  'data-method':"patch", 'href':`/answers/${answerId}/set_best`})
                          .text('Best')
                          .appendTo('<p/>')

      $(`#answer-${answerId}`).append(best)
    }
  });
});
