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

    def sub_sections(section)
      path = "/#{section}/index/#{date_str}/"
      uri = base_uri.dup
      uri.path = path
      parse_html(uri.to_s) do |doc|
        select = doc.css("#article_ddl").first
        links = {}
        {}.tap do |result|
          select.css("optgroup").each do |group|
            sub_section = group.attribute("label").value
            group.css("option").each do |option|
              link = option.attribute('value').value.split('/')[-2, 2].join('/')
              title = option.text
              result[{:link => link, :title => title}] = sub_section
            end
          end
        end.collect{|k, v| k[:sub_section] = v; k}
      end
    end

    def article(article_id)
      path = "/news/art/#{date_str}/#{article_id}"
      uri = base_uri.dup
      uri.path = path
      parse_html(uri.to_s) do |doc|
        content = doc.css("#articleContent").first
        {}.tap do |result|
          result[:media] = doc.to_s.scan(/url ?: ?'(.*?\.mp4)'/).flatten
          result[:title] = content.css('h1').first.text.strip
          result[:content] = content.css('#masterContent').inner_html.strip
        end
      end
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
      options[:headers] ||= {}
      options[:headers]["Cookie"] ="FREE_TOKEN=1"
      super(url, options)
    end
  end
end
