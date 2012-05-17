require 'newsparser'
require 'newsparser/mingpao'

require 'sinatra/base'
require 'oj'
require 'multi_json'
require 'api/mingpao'

module Api
  class Server < Sinatra::Base
    include Api::Mingpao
  end
end
