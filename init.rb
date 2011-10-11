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
      headers['Cache-Control'] = "public; max-age=#{365*24*60*60}"
    end
        
    get '/location/:ip' do
      begin
        response = GEOIP.city params[:ip]
        response = response ? { :status => 'ok', :city => response.to_hash[:city_name] }.to_json : { :status => 'not found', :message => "City not found" }.to_json
      rescue => e
        error 500, e.message.to_json
      end
    end
  end
end
