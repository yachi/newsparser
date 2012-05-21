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
end
