module Api
  module Apple
    def self.included(base)
      base.class_eval do
        helpers do
          def render_result
            MultiJson.dump @result
          end
        end

        get '/apple/sections' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result ||= @apple.sections
          @result.each do |result|
            run_later do
              host = "http://#{request.host}:#{request.port}"
              path = "/api/apple/subsections/#{result[:link]}"
              uri = URI.join(host, path)
              uri.query = "d=#{@apple.date_str}"
              HTTParty.get(uri.to_s)
            end
          end
          render_result
        end

        get '/apple/subsections/:sub' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result ||= @apple.sub_sections(params['sub'])
          @result.each do |result|
            run_later do
              host = "http://#{request.host}:#{request.port}"
              path = "/api/apple/articles/#{result[:link].split('/')[1]}"
              uri = URI.join(host, path)
              uri.query = "d=#{@apple.date_str}"
              HTTParty.get(uri.to_s)
            end
          end
          render_result
        end

        get '/apple/articles/:art' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @apple.s_id = params['s'] if params['s'].to_s[/\w+/]
          @result ||= @apple.article(params[:art])
          render_result
        end
      end
    end
  end
end
