require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'sinatra/cross_origin'

require 'api/server/run_later'

require 'newsparser'
require 'newsparser/mingpao'

require 'api/mingpao'
require 'api/apple'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
    include Api::Apple

    register Sinatra::CrossOrigin

    use Rack::Logger
    helpers do
      def logger
        request.logger
      end
    end
    helpers Sinatra::RunLater::InstanceMethods

    configure do
      enable :cross_origin
      if ENV['MEMCACHE_SERVERS']
        puts ENV['MEMCACHE_SERVERS']
        puts ENV['MEMCACHE_USERNAME']
        puts ENV['MEMCACHE_PASSWORD']
        set :cache, Dalli::Client.new( ENV['MEMCACHE_SERVERS'],
                                       :username => ENV['MEMCACHE_USERNAME'],
                                       :password => ENV['MEMCACHE_PASSWORD'],
                                       :expires_in => 3600 * 24)
        puts "finished setting memcache settings"
      else
        set :cache, Dalli::Client.new
      end
      set :enable_cache, true
    end

    before do
      if request.request_method == 'OPTIONS'
        cross_origin
        response.headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")
        halt 200
      end
    end

    before do
      puts "start cache key block"
      keys = request.path.split('/')
      keys << ['d', params['d'].to_s]
      @_cache_key = keys.join('/')
      puts "finished cache key block"

      puts "start get cache block"
      if value = settings.cache.get(@_cache_key)
        logger.info 'got cache with key: ' << @_cache_key
        @_cache_exists = true
        @result = value
      end
      puts "finished get cache block"
    end

    after do
      if response.status == 200
        cache_control :public, :must_revalidate, :max_age => 3600
      end
      puts "start set cache block"
      if !@_cache_exists and @_cache_key and @result
        logger.info 'setting cache with key: ' << @_cache_key
        settings.cache.set(@_cache_key, @result)
      end
      puts "finished set cache block"
    end
  end
end
