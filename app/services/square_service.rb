require 'net/http'
require 'uri'
require 'json'

class SquareService
  URL = 'https://connect.squareupsandbox.com/v2'

  def create_customer(email, given_name, idempotency_key)
    url = URI("#{URL}/customers")
    http = set_host_and_port(url)
    request = set_request_header(url, "post", ENV['SQUARE_PAYMENT_TOKEN'])
    request.body = {
      idempotency_key: idempotency_key,
      email_address: email,
      given_name: given_name
    }.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end


  def create_payment(idempotency_key, amount_money, source_id)
    url = URI("#{URL}/payments")
    http = set_host_and_port(url)
    request = set_request_header(url, "post", ENV['SQUARE_PAYMENT_TOKEN'])
    request.body = {
      idempotency_key: idempotency_key,
      amount_money: amount_money,
      source_id: source_id
    }.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end

  def create_order(idempotency_key, location_id, order_data)
    url = URI("#{URL}/orders")
    http = set_host_and_port(url)
    request = set_request_header(url, "post", ENV['SQUARE_PAYMENT_TOKEN'])
    
    request.body = {
      idempotency_key: idempotency_key,
      order: {
        location_id: location_id,
        line_items: order_data[:line_items]
      }
    }.to_json
  
    response = http.request(request)
    JSON.parse(response.body)
  end
  
  

  def set_request_header(url, type, access_token)
    request = case type
              when "get"
                Net::HTTP::Get.new(url)
              when "post"
                Net::HTTP::Post.new(url)
              when "put"
                Net::HTTP::Put.new(url)
              when "delete"
                Net::HTTP::Delete.new(url)
              else
                raise "Invalid request type"
              end
    request["Square-Version"] = ENV['SQUARE_PAYMENT_VERSION']
    request["Content-Type"] = 'application/json'
    request["Accept"] = 'application/json'
    request["Authorization"] = "Bearer #{access_token}"
    request
  end

  def set_host_and_port(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http
  end
end
