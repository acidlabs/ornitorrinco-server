require 'yajl/json_gem'

module Ornitorrinco  
  class Init < Sinatra::Base
    register Sinatra::Cache
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'
      uri = URI.parse(ENV["REDISTOGO_URL"])
      REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
      GEOIP = GeoIP.new('config/GeoLiteCity.dat')
    end
    
    mime_type :json, 'application/json'
    
    before do
      content_type :json
      headers['Cache-Control'] = "public; max-age=#{365*24*60*60}"
    end
    
    get '/' do
      response = GEOIP.city request.ip
      response = response ? { :status => 'ok', :city => response.to_hash[:city_name] }.to_json : { :status => 'not found', :message => "City not found" }.to_json
    end
  
  end
end
