require 'test_helper'

module LaDepartmentWatcher
  class DepartmentMailerTest < ActionMailer::TestCase
    test "notify_alert" do
      mail = DepartmentMailer.notify_alert
      assert_equal "Notify alert", mail.subject
      assert_equal ["to@example.org"], mail.to
      assert_equal ["from@example.com"], mail.from
      assert_match "Hi", mail.body.encoded
    end
  
  end
end
