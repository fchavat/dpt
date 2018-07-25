require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "Compra realizada.", mail.subject
    assert_equal ["asd@asd.com"], mail.to
    assert_equal ["felipe.chavat@gmail.com"], mail.from
    assert_match "Hola", mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Order was shipped", mail.subject
    assert_equal ["asd@asd.com"], mail.to
    assert_equal ["felipe.chavat@gmail.com"], mail.from
    assert_match "Hola", mail.body.encoded
  end

end
