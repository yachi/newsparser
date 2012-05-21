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
      it "returns a hash with link, title and sub_section for section: #{section}" do
        apple = Newsparser::Apple.new
        result = apple.sub_sections('news')
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
      end
    end
  end

  describe "#article" do
    it "returns a hash with media, title, content" do
      apple = Newsparser::Apple.new
      result = apple.article('20120521/16354644')
      result.should be_kind_of Hash
      result[:content].should be_kind_of(String)
      result[:media].should be_kind_of(Array)
      result[:title].should be_kind_of(String)
    end
  end
end
