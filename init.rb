require 'yajl/json_gem'

module Ornitorrinco  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'      
      
      GEOIP = GeoIP.new('config/GeoLiteCity.dat')
      
      uri = URI.parse(ENV["REDISTOGO_URL"])
      set :cache, Sinatra::Cache::RedisStore.new(:host => uri.host, :port => uri.port, :password => uri.password)
      set :cache_enabled, true
    end
    
    mime_type :json, 'application/json'
    
    before do
      content_type :json
      cache_control :public, :max_age => "#{365*24*60*60}".to_i
    end
        
    get '/location/:ip' do
      begin        
        city = 
          if request = GEOIP.city(params[:ip])
            settings.cache.fetch("#{params[:ip]}") { "#{request.to_hash[:city_name]}" }
          else
            settings.cache.fetch("#{params[:ip]}") { "not found" }
          end
        
        { :city => city }.to_json
      rescue => e
        error 500, e.message.to_json
      end
    end
    
  end
end
