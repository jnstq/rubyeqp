require File.dirname(__FILE__) + '/spec_helper'

describe TranslateHelper do
  before(:each) do
    ENV['TM_PROJECT_DIRECTORY'] = File.dirname(__FILE__) + '/fixtures'    
  end
  it "should find available locales" do
    TranslateHelper::locales.should eql(['en-US','sv-SE'])
  end
  it "should return locale path" do
    TranslateHelper.locale_path.should eql(File.join(File.dirname(__FILE__), 'fixtures','config', 'locales', 'site'))
  end
  it "should have instance method for locale path" do
    TranslateHelper.new(:'sv-SE').send(:locale_path).should eql(TranslateHelper.locale_path)    
  end
  it "should lookup key for given translation" do
    TranslateHelper.keys_for('Hej').should eql(['en-US.txt.hello'.split('.')])
  end
end
