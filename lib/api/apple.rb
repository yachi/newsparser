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
          keys = request.path.split('/')
          keys << ['d', params['d']]
          @_cache_key = keys.join('/')

          if value = settings.cache.get(@_cache_key)
            logger.info 'got cache with key: ' << @_cache_key
            @_cache_exists = true
            @result = value
          end
        end

        after do
          if response.status == 200
            cache_control :public, :must_revalidate, :max_age => 3600
          end
          unless @_cache_exists
            logger.info 'setting cache with key: ' << @_cache_key
            settings.cache.set(@_cache_key, @result)
          end
        end

        get '/api/apple/sections' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result ||= @apple.sections
          render_result
        end

        get '/api/apple/subsections/:sub' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result ||= @apple.sub_sections(params[:sub])
          render_result
        end

        get '/api/apple/articles/:art' do
          @apple = Newsparser::Apple.new
          @apple.date_str = params['d'] if params['d'].to_s[/\d{8}/]
          @result ||= @apple.article(params[:art])
          render_result
        end
      end
    end
  end
end
