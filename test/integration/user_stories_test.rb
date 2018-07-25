require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  setup do
    setup_login
  end

  # test "the truth" do
  #   assert true
  # end
  test 'buying a product' do
    start_order_count = Order.count
    camiseta = products(:camiseta)
    get '/'
    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalog'

    # Agregamos un line_item al carrito
    post '/line_items', params: { product_id: camiseta.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal camiseta, cart.line_items[0].product

    # Hacemos el checkout del carrito
    get '/orders/new'
    assert_response :success
    assert_select 'h1', 'New Order'

    post '/orders', params: {
      order: {
        name:         'Felipe Chavat',
        address:      '123 The Street',
        email:        'felipe.chavat@gmail.com',
        pay_type:     'Check'
      }
    }
    follow_redirect!

    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalog'
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # Check if the order was created and if the information is right
    assert_equal start_order_count + 1, Order.count
    order = Order.last

    assert_equal "Felipe Chavat", order.name
    assert_equal "felipe.chavat@gmail.com", order.email
    assert_equal '123 The Street', order.address
    assert_equal 'Check', order.pay_type

    # Check if the "received" mail was sent
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["felipe.chavat@gmail.com"], mail.to
    assert_equal 'Felipe Chavat <felipe.chavat@gmail.com>', mail[:from].value
    assert_equal 'Compra realizada.', mail.subject

  end
end
