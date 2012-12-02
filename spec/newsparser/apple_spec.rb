# encoding: UTF-8

require 'spec_helper'

describe Newsparser::Apple do
  describe "#sections" do
    it "returns a hash with links and sections" do
      apple = Newsparser::Apple.new
      result = apple.sections
      result.should be_kind_of Array
      result.first.should have_key(:link)
      result.first.should have_value("news")
    end
  end

  describe "#sub_sections" do
    Newsparser::Apple::SECTIONS.keys.each do |section|
      context "section = #{section}" do
        it "returns a hash with link, title and sub_section for section: #{section}" do
          apple = Newsparser::Apple.new
          result = apple.sub_sections(section)
          result.should be_kind_of Array
          result.first.should have_key(:link)
          result.each do |r|
            r[:link].should match(/\d+\/\d+/)
          end
          result.first.should have_key(:title)
          result.each do |r|
            r[:title].should_not be_empty
          end
          result.first.should have_key(:sub_section)
          result.each do |r|
            r[:sub_section].should_not be_empty
          end
          if section == 'supplement'
            result.first.should have_key(:section)
            result.each do |r|
              r[:section].should_not be_empty
            end
          end
        end
      end
    end
  end

  describe "#article" do
    it "returns a hash with media, title, content" do
      apple = Newsparser::Apple.new
      apple.date_str='20120521'
      apple.s_id = 'news'
      result = apple.article('16354644')
      result.should be_kind_of Hash
      result[:content].should be_kind_of(String)
      result[:media].should be_kind_of(Hash)
      result[:title].should be_kind_of(String)
      result[:original_url].should be_kind_of(String)
    end

    it "returns a hash without photos in next article" do
      apple = Newsparser::Apple.new
      apple.date_str='20121202'
      apple.s_id = 'news'
      result = apple.article('18087795')
      result.should be_kind_of Hash
      result[:content].should be_kind_of(String)
      result[:content].should_not match("http://static.apple.nextmedia.com/images/apple-photos/apple/20121202/small/02la3p1.jpg")
      result[:media].should be_nil
      result[:title].should be_kind_of(String)
      result[:original_url].should be_kind_of(String)
    end

    context "supplement article" do
      it "returns a hash with title, content" do
        apple = Newsparser::Apple.new
        apple.date_str = '20120610'
        apple.s_id = 'supplement'
        result = apple.article('16411943')
        result.should be_kind_of Hash
        result[:content].should be_kind_of(String)
        result[:title].should be_kind_of(String)
        result[:original_url].should be_kind_of(String)
      end
    end

    context "article that contains photo" do
      it "returns a hash with title, content" do
        apple = Newsparser::Apple.new
        apple.date_str = '20120610'
        apple.s_id = 'realtime'
        result = apple.article('50091526')
        result.should be_kind_of Hash
        result[:content].should be_kind_of(String)
        result[:title].should be_kind_of(String)
        result[:original_url].should be_kind_of(String)
        Nokogiri::HTML(result[:content]).css('.photo').count.should > 0
      end
    end

    context "article that contains video" do
      context "realtime" do
        it "returns a hash with title, content" do
          apple = Newsparser::Apple.new
          apple.date_str = '20120612'
          apple.s_id = 'realtime'
          result = apple.article('50091823')
          result.should be_kind_of Hash
          result[:content].should be_kind_of(String)
          result[:title].should be_kind_of(String)
          result[:media].should be_kind_of(Hash)
          result[:media][:url].should be_kind_of(String)
          result[:original_url].should be_kind_of(String)
        end
      end
      context "news" do
        it "returns a hash with title, content" do
          apple = Newsparser::Apple.new
          apple.date_str = '20120612'
          apple.s_id = 'news'
          result = apple.article('16418488')
          result.should be_kind_of Hash
          result[:content].should be_kind_of(String)
          result[:title].should be_kind_of(String)
          result[:media].should be_kind_of(Hash)
          result[:media][:url].should be_kind_of(String)
          result[:original_url].should be_kind_of(String)
        end
      end
    end
    context "article that contains parallel images" do
      before :each do
        apple = Newsparser::Apple.new
        apple.date_str = '20120619'
        apple.s_id = 'news'
        result = apple.article('16438804')
        @content = Nokogiri::HTML(result[:content])
      end
      it "should have width removed in images" do
        @content.css('img').each do |img|
          img.attribute('width').should be_nil
        end
      end
      it "should be unwrapped from table" do
        @content.css('img').each do |img|
          pending "may look good for small images"
          img.parent.parent.name.should_not == "td"
          img.parent.parent.name.should_not == "tr"
          img.parent.parent.name.should_not == "table"
        end
      end
    end
  end
end
