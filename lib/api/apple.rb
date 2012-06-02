module Api
  module Apple
    def self.included(base)
      base.class_eval do
        helpers do
          def render_result
            MultiJson.dump @result
          end
        end

        before do
          cache_control :public, :must_revalidate, :max_age => 3600
        end

        get '/api/apple/sections' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result = @apple.sections
          render_result
        end

        get '/api/apple/subsections/:sub' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result = @apple.sub_sections(params[:sub])
          render_result
        end

        get '/api/apple/articles/:art' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result = @apple.article(params[:art])
          render_result
        end
      end
    end
  end
end
