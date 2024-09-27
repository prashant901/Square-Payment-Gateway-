class OrdersController < ApplicationController
    def new
      
    end
  
    def create
      idempotency_key = SecureRandom.uuid
      location_id = ENV['SQUARE_LOCATION_ID']
      order = build_order(params[:order_items])
  
      square_service = SquareService.new
      response = square_service.create_order(idempotency_key, location_id, order)
  
      if response['errors']
        flash[:error] = response['errors'].first['detail']
        render :new
      else
        flash[:notice] = "Order created successfully!"
        redirect_to root_path
      end
    end
  
    private
  
    def build_order(order_items)
      items = order_items.map do |item|
        {
          name: item[:name],
          quantity: item[:quantity].to_s,
          base_price_money: { amount: (item[:price].to_f * 100).to_i, currency: 'USD' }
        }
      end
  
      {
        line_items: items
      }
    end
  end
  