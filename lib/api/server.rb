require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'newsparser'
require 'newsparser/mingpao'

require 'api/mingpao'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
  end
end
