require 'test_helper'

class DownServiceNotifierTest < ActionMailer::TestCase
  test "notify_down_service" do
    mail = DownServiceNotifier.notify_down_service
    assert_equal "Notify down service", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
