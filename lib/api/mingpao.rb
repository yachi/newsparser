module Api
  module Mingpao
    def self.included(base)
      base.class_eval do
        helpers do
          def render_result
            MultiJson.dump @result
          end
        end

        get '/api/mingpao/sections' do
          content_type :json
          @mingpao = Newsparser::Mingpao.new
          @result = @mingpao.sections(params['d'])
          render_result
        end

        get '/api/mingpao/subsections/:sub' do
          content_type :json
          @mingpao = Newsparser::Mingpao.new
          @result = @mingpao.sub_sections(params['d'], params[:sub])
          render_result
        end

        get '/api/mingpao/articles/:art' do
          content_type :json
          @mingpao = Newsparser::Mingpao.new
          @result = @mingpao.article(params['d'], params[:art])
          render_result
        end
      end
    end
  end
end
