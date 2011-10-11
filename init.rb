require 'yajl/json_gem'

module Ornitorrinco  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'      
      
      GEOIP = GeoIP.new('config/GeoLiteCity.dat')
      
      #uri = URI.parse ENV['REDIS_URL']
      #set :cache, Sinatra::Cache::RedisStore.new(:host => uri.host, :port => uri.port, :password => uri.password)
      #set :cable_enabled, true
      
      uri = URI.parse(ENV["REDISTOGO_URL"])
      REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
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
        #URI.parse ENV['REDIS_URL']
      end
    end
  end
end
