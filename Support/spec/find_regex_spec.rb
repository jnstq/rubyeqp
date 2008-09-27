require File.dirname(__FILE__) + '/spec_helper'

describe FindRegex do
  
  it "should should find normal regex on the current line" do
    FindRegex.parse("this is a /test/ message").should eql("test")
  end

  it "should should find a regex within %r" do
    FindRegex.parse("this is a %r'test' message").should eql("test")    
  end
  
  it "should should find a regex within dubbel qoute %r" do
    FindRegex.parse("this is a %r\"test\" message").should eql("test")    
  end
  
  it "should should find a regex within pipe and %r" do
    FindRegex.parse("this is a %r|test| message").should eql("test")    
  end
  
  it "should should find a regex within param and %r" do
    FindRegex.parse("this is a %r(test) message").should eql("test")    
  end  
  
  it "should should find a regex within hak-parantes and %r" do
    FindRegex.parse("this is a %r[test] message").should eql("test")    
  end  
  
  it "should should find a regex within hak-parantes and %r" do
    FindRegex.parse("this is a %r{test} message").should eql("test")    
  end 
  
  it "should find a real regex example #1" do
    FindRegex.parse("return $1 if line =~ /\/(.*)\//").should eql("\/(.*)\/")    
  end 
  
  it "should find a real regex example #2" do
    FindRegex.parse("this is a regex /%r(.){1}(.+)(\1|[)\]}]){1}/ with a real regex").should eql("%r(.){1}(.+)(\1|[)\]}]){1}")    
  end   
  
  it "should find a real regex example #3" do
    FindRegex.parse("this is a regex %r'(.){1}(.+)(\1|[)\]}]){1}' with a real regex").should eql("(.){1}(.+)(\1|[)\]}]){1}")    
  end     
    
end