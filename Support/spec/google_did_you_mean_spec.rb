require File.dirname(__FILE__) + '/spec_helper'

describe Google do
  before(:each) do
    @abbr = Google::DidYouMean.new
  end
  it "should search google for did you mean" do
    @abbr.check("exalty").should eql("exactly")
  end
  
  it "should split word seperated by underline and search on this seperate" do
    @abbr.check("mulipy_exalty").should eql("multiply_exactly")    
  end
  
  it "should contain description for the changes" do
    @abbr.check("multiply_exalty")
    @abbr.tool_tip.should eql("No 'Did you mean' found for multiply.\nexalty changed to exactly.")    
  end  
  
  it "should return if one or more words is corrected" do
    @abbr.check("exalty")
    @abbr.should be_found
  end
  
  it "should reset instance variables" do
    @abbr.found = true
    @abbr.tool_tip = "test"    
    @abbr.reset
    @abbr.should_not be_found
    @abbr.tool_tip.should be_empty
  end
  
end