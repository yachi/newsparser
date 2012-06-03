require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'sinatra/cross_origin'

require 'newsparser'
require 'newsparser/mingpao'

require 'api/mingpao'
require 'api/apple'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
    include Api::Apple

    register Sinatra::CrossOrigin

    configure do
      enable :cross_origin
      if ENV['MEMCACHE_SERVERS']
        set :cache, Dalli::Client.new( ENV['MEMCACHE_SERVERS'],
                                       :username => ENV['MEMCACHE_USERNAME'],
                                       :password => ENV['MEMCACHE_PASSWORD'],
                                       :expires_in => 3600 * 24)
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

    use Rack::Logger
    helpers do
      def logger
        request.logger
      end
    end
  end
end
