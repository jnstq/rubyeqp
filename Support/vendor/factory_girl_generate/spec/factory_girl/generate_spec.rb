require File.dirname(__FILE__) + '/../spec_helper'

describe FactoryGirl::Generate do
  
  before(:each) do
    @it = FactoryGirl::Generate.new
  end
  
  it "should return example value for number" do
    @it.value_for(User.columns_hash["number"]).should eql('1')
  end
  
  it "should return example value for string" do
    @it.value_for(User.columns_hash["username"]).should eql('"Value for username"')
  end
  
  it "should return example value for datetime" do
    @it.value_for(Post.columns_hash["created_at"]).should eql('{ Time.now }')
  end
  
  it "should return example value for date" do
    @it.value_for(Post.columns_hash["starts_on"]).should eql('{ Time.now.to_date }')
  end
  
  it "should render factory for user" do
    FactoryGirl::Generate.new.render_factory_for(User).should eql(%Q[Factory.define :user do |u|
  u.number 1
  u.username "Value for username"
  u.password "Value for password"
end])
  end
  
  it "should not render updated_at and created_at" do
    @it.render_factory_for(Post).should_not match(/updated_at|created_at/)
  end
end
