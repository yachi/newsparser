module Api
  module Mingpao
    def self.included(base)
      base.class_eval do
        helpers do
          def render_result
            Yajl::Encoder.encode @result
          end
        end

        get '/api/mingpao/sections' do
          content_type :json
          @mingpao = Newsparser::Mingpao.new
          @result = @mingpao.sections
          render_result
        end

        get '/api/mingpao/subsections/:sub' do
          content_type :json
          @mingpao = Newsparser::Mingpao.new
          @result = @mingpao.sub_sections(nil, params[:sub])
          render_result
        end

        get '/api/mingpao/articles/:art' do
          content_type :json
          @mingpao = Newsparser::Mingpao.new
          @result = @mingpao.article(nil, params[:art])
          render_result
        end
      end
    end
  end
end
