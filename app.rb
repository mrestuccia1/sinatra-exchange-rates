require "sinatra"
require "sinatra/reloader"
require "json"
require "http"

get("/") do
  KEY = ENV['EXCHANGE_RATES_KEY']
  api_url = "http://api.exchangerate.host/list?access_key=#{KEY}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)
  @parsed = parsed_data["currencies"]
  erb(:index)
end

get("/:currency") do
  @original_currency = params.fetch("currency")
  KEY = ENV['EXCHANGE_RATES_KEY']

  api_url = "http://api.exchangerate.host/list?access_key=#{KEY}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)
  @parsed = parsed_data["currencies"]

  erb(:currency)

end

get("/:from_currency/:to_currency") do
  KEY = ENV['EXCHANGE_RATES_KEY']
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "http://api.exchangerate.host/convert?access_key=#{KEY}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)
  @converted = parsed_data["currencies"]

  erb(:rate)
end
