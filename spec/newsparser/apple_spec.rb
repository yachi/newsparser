# encoding: UTF-8

require 'spec_helper'

describe Newsparser::Apple do
  describe "#sections" do
    it "returns a hash with links and sections" do
      apple = Newsparser::Apple.new
      result = apple.sections
      expect(result).to be_kind_of Array
      expect(result.first).to have_key(:link)
      expect(result.first).to have_value("news")
    end
  end

  describe "#sub_sections" do
    Newsparser::Apple::SECTIONS.keys.each do |section|
      context "section = #{section}" do
        it "returns a hash with link, title and sub_section for section: #{section}" do
          apple = Newsparser::Apple.new
          result = apple.sub_sections(section)
          expect(result).to be_kind_of Array
          expect(result.first).to have_key(:link)
          result.each do |r|
            expect(r[:link]).to match(/\d+\/\d+/)
          end
          expect(result.first).to have_key(:title)
          result.each do |r|
            expect(r[:title]).not_to be_empty
          end
          expect(result.first).to have_key(:sub_section)
          result.each do |r|
            expect(r[:sub_section]).not_to be_empty
          end
          if section == 'supplement'
            expect(result.first).to have_key(:section)
            result.each do |r|
              expect(r[:section]).not_to be_empty
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
      expect(result).to be_kind_of Hash
      expect(result[:content]).to be_kind_of(String)
      expect(result[:media]).to be_kind_of(Hash)
      expect(result[:title]).to be_kind_of(String)
      expect(result[:original_url]).to be_kind_of(String)
    end

    it "returns a hash without photos in next article" do
      apple = Newsparser::Apple.new
      apple.date_str='20121202'
      apple.s_id = 'news'
      result = apple.article('18087795')
      expect(result).to be_kind_of Hash
      expect(result[:content]).to be_kind_of(String)
      expect(result[:content]).not_to match("http://static.apple.nextmedia.com/images/apple-photos/apple/20121202/small/02la3p1.jpg")
      expect(result[:media]).to be_nil
      expect(result[:title]).to be_kind_of(String)
      expect(result[:original_url]).to be_kind_of(String)
    end

    context "supplement article" do
      it "returns a hash with title, content" do
        apple = Newsparser::Apple.new
        apple.date_str = '20120610'
        apple.s_id = 'supplement'
        result = apple.article('16411943')
        expect(result).to be_kind_of Hash
        expect(result[:content]).to be_kind_of(String)
        expect(result[:title]).to be_kind_of(String)
        expect(result[:original_url]).to be_kind_of(String)
      end
    end

    context "article that contains photo" do
      it "returns a hash with title, content" do
        apple = Newsparser::Apple.new
        apple.date_str = '20120610'
        apple.s_id = 'realtime'
        result = apple.article('50091526')
        expect(result).to be_kind_of Hash
        expect(result[:content]).to be_kind_of(String)
        expect(result[:title]).to be_kind_of(String)
        expect(result[:original_url]).to be_kind_of(String)
        expect(Nokogiri::HTML(result[:content]).css('.photo').count).to be > 0
      end
    end

    context "article that contains video" do
      context "realtime" do
        it "returns a hash with title, content" do
          apple = Newsparser::Apple.new
          apple.date_str = '20120612'
          apple.s_id = 'realtime'
          result = apple.article('50091823')
          expect(result).to be_kind_of Hash
          expect(result[:content]).to be_kind_of(String)
          expect(result[:title]).to be_kind_of(String)
          expect(result[:media]).to be_kind_of(Hash)
          expect(result[:media][:url]).to be_kind_of(String)
          expect(result[:original_url]).to be_kind_of(String)
        end
      end
      context "news" do
        it "returns a hash with title, content" do
          apple = Newsparser::Apple.new
          apple.date_str = '20120612'
          apple.s_id = 'news'
          result = apple.article('16418488')
          expect(result).to be_kind_of Hash
          expect(result[:content]).to be_kind_of(String)
          expect(result[:title]).to be_kind_of(String)
          expect(result[:media]).to be_kind_of(Hash)
          expect(result[:media][:url]).to be_kind_of(String)
          expect(result[:original_url]).to be_kind_of(String)
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
          expect(img.attribute('width')).to be_nil
        end
      end
      it "should be unwrapped from table" do
        @content.css('img').each do |img|
          pending "may look good for small images"
          expect(img.parent.parent.name).not_to eq "td"
          expect(img.parent.parent.name).not_to eq "tr"
          expect(img.parent.parent.name).not_to eq "table"
        end
      end
    end
  end
end
