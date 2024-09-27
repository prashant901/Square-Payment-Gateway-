class CustomersController < ApplicationController
    def new

    end
  
    def create
      email = params[:email]
      given_name = params[:given_name]
      idempotency_key = SecureRandom.uuid
  
      square_service = SquareService.new
      response = square_service.create_customer(email, given_name, idempotency_key)
  
      if response['errors']
        flash[:error] = response['errors'].first['detail']
        render :new
      else
        flash[:notice] = "Customer created successfully!"
        redirect_to root_path
      end
    end
  end
  