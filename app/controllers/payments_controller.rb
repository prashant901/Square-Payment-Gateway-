class PaymentsController < ApplicationController
    def new
      
    end
  
    def create
      idempotency_key = SecureRandom.uuid
      amount_money = { amount: params[:amount].to_i, currency: 'USD' }
      source_id = params[:source_id] # This is the token generated from Square's payment form
  
      square_service = SquareService.new
      response = square_service.create_payment(idempotency_key, amount_money, source_id)
  
      if response['errors']
        flash[:error] = response['errors'].first['detail']
        render :new
      else
        flash[:notice] = "Payment processed successfully!"
        redirect_to root_path
      end
    end
  end
  