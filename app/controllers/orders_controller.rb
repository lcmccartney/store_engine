class OrdersController < ApplicationController
  def index
    @orders = Order.all
    authorize! :manage, Order

    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  def show
    @order = Order.find(params[:id])
    authorize! :read, Order

    render :show
  end

  def change_status
    order = Order.find(params[:id])
    order.status = params[:status]
    order.save
    redirect_to "/admin"
  end

  def new
    @order = Order.new
    authorize! :create, Order

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find(params[:id])
    authorize! :update, Order
  end

  def create
    unless current_user
      flash[:error] = 'You must be logged in to checkout. Please, login or create an account.'
      redirect_to login_path and return
    end

    if Order.create_from_cart_for_user(current_cart, current_user)
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to root_path, notice: 'Thanks! Your order was successfully submitted.'
    else
      render action: "new"
    end
  end

  def update
    @order = Order.find(params[:id])
  
    if @order.update_attributes(params[:order])
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render action: "edit" 
    end  
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    redirect_to orders_url
  end
end