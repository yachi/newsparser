require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'api/server/run_later'

require 'newsparser'
require 'newsparser/mingpao'

require 'api/mingpao'
require 'api/apple'

require 'dalli'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
    include Api::Apple

    use Rack::Logger
    helpers do
      def logger
        request.logger
      end
    end
    helpers Sinatra::RunLater::InstanceMethods

    configure do
      if ENV['MEMCACHIER_SERVERS']
        set :cache, Dalli::Client.new( ENV['MEMCACHIER_SERVERS'],
                                       :username => ENV['MEMCACHIER_USERNAME'],
                                       :password => ENV['MEMCACHIER_PASSWORD'],
                                       :expires_in => 3600 * 24)
      else
        set :cache, Dalli::Client.new
      end
      set :enable_cache, true
    end

    before do
      response.headers["Access-Control-Allow-Origin"]  = "*"
      response.headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
      response.headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type Cache-Control X-Requested-With X-CSRF-Token}.join(",")
      if request.request_method == 'OPTIONS'
        halt 200
      end
    end

    before do
      keys = request.path.split('/')
      keys << ['d', params['d'].to_s] if params['d']
      keys << ['s', params['s'].to_s] if params['s']
      @_cache_key = keys.flatten.join('/')

      unless @_cache_key[/realtime/]
        if value = settings.cache.get(@_cache_key)
          logger.info 'got cache with key: ' << @_cache_key
          @_cache_exists = true
          @result = value
        end
      end
    end

    after do
      if @_cache_key[/realtime/]
        expires_in = 600
      else
        expires_in = 3600 + (rand * 600).to_i
      end
      if response.status == 200
        cache_control :public, :must_revalidate, :max_age => expires_in
      end
      if !@_cache_exists and @_cache_key and @result
        logger.info 'setting cache with key: ' << @_cache_key
        settings.cache.set(@_cache_key, @result, expires_in)
      end
      content_type 'application/json'
    end
  end
end
