# encoding: UTF-8

module Newsparser
  class Apple < Base
    BASE_URL = "http://hk.apple.nextmedia.com/"

    SECTIONS = {"news"=>"要聞港聞",
      "international"=>"兩岸國際",
      "entertainment"=>"娛樂名人",
      "financeestate"=>"財經地產",
      "sports"=>"體育",
      "supplement"=>"副刊"
    }

    attr_accessor :date_str

    def sections
      return SECTIONS.collect{|k, v| {:link => k, :title => v}}
      #path = "/catalog/index/#{date_str}/"
      #uri = base_uri.dup
      #uri.path = path
      #parse_html(uri.to_s) do |doc|
      #  doc.css(".category").collect(&:text)
      #end
    end

    def date_str
      # Treat HKT 5AM as a new day
      @date_str ||= (Time.now.utc - 5 * 3600).strftime('%Y%m%d')
    end
    private

    def base_uri
      @base_uri ||= URI.parse(BASE_URL)
    end

    def get_url(url, options)
      options[:headers] = {"Cookie" => "FREE_TOKEN=1"}
      super(url, options)
    end
  end
end
