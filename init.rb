require 'yajl/json_gem'
require 'sinatra/cache'

module Ornitorrinco  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'
      
      GEOIP = GeoIP.new('config/GeoLiteCity.dat')
      
      register Sinatra::Cache
      set :cache_enabled, true
      #set :redis_store, RedisStore.new(ENV['REDIS_URL'])
    end
    
    mime_type :json, 'application/json'
    
    before do
      content_type :json
      cache_control :public, :max_age => "#{365*24*60*60}".to_i
    end
        
    get '/location/:ip' do
      begin
        response = GEOIP.city params[:ip]
        response = response ? { :status => 'ok', :city => response.to_hash[:city_name] }.to_json : { :status => 'not found', :message => "City not found" }.to_json
        settings.cache.fetch("greet") { "Hello, World!" }
      rescue => e
        error 500, e.message.to_json
      end
    end
  end
end
