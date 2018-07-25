class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize
  def index
    if session[:counter].nil?
      session[:counter] = 0
    else
      session[:counter] += 1
    end
    @visit_count = session[:counter]
    @products = Product.order(:title)
  end
end
