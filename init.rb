require 'yajl/json_gem'

module Ornitorrinco  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'
      GEOIP = GeoIP.new('config/GeoLiteCity.dat')
    end
    
    mime_type :json, 'application/json'
    
    before do
      content_type :json
    end
    
    get '/' do
      begin
        response = GEOIP.city request.ip
        response ? response.to_json : raise(Error)
      rescue
        "City not found".to_json
      end
    end
  
  end
end
