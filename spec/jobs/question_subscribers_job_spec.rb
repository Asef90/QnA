require 'rails_helper'

RSpec.describe QuestionSubscribersJob, type: :job do
  let(:subscriber) { create(:user) }
  let!(:not_subscriber) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, :on_question, subscriptable: question, user: subscriber) }
  let!(:answer) { create(:answer, question: question) }

  it 'expect call of QuestionSubscribersMailer' do
    expect(QuestionSubscribersMailer).to receive(:notification).with(subscriber, answer).and_call_original
    QuestionSubscribersJob.perform_now(answer)
  end

  it 'adds job with email sending to subscriber' do
    expect { QuestionSubscribersJob.perform_now(answer) }.to have_enqueued_job
                                   .with('QuestionSubscribersMailer', 'notification', 'deliver_now', args: [ subscriber, answer ])
  end

  it 'does not adds job with email sending to not subscriber' do
    expect { QuestionSubscribersJob.perform_now(answer) }.not_to have_enqueued_job
                                   .with('QuestionSubscribersMailer', 'notification', 'deliver_now', args: [ not_subscriber, answer ])
  end
end
