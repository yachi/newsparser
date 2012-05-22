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
  end
end
