require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'newsparser'
require 'newsparser/mingpao'

require 'api/mingpao'
require 'api/apple'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
    include Api::Apple

    configure do
      enable :cross_origin
    end

    before do
      if request.request_method == 'OPTIONS'
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Methods"] = "GET"
        response.headers["Access-Control-Allow-Headers"] = "X-Requested-With"

        halt 200
      end
    end
  end
end
