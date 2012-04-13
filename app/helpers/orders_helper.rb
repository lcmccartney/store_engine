module OrdersHelper
  def current_order
    return Order.find(session[:order_id]) if session[:order_id]
  end
  def require_order
    if current_order.nil? || current_order != @order
      redirect_to root_url, notice: "Sorry, you are not allowed to view that page"
    end
  end
end
