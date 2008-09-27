require File.dirname(__FILE__) + '/spec_helper'
require "tempfile"

describe RDoc do

  before(:each) do
    @rdoc = RDoc.new
    @rdoc.stub!(:puts).and_return(nil)    
    @rdoc.should_receive(:open).any_number_of_times.with("http://www.ruby-doc.org/core/fr_method_index.html").and_return(open(File.dirname(__FILE__) + "/fixtures/www.ruby-doc.org.html"))
    @rdoc.should_receive(:open).any_number_of_times.with("http://api.rubyonrails.com/fr_method_index.html").and_return(open(File.dirname(__FILE__) + "/fixtures/api.rubyonrails.com.html"))
    @rdoc.should_receive(:open).any_number_of_times.with("http://jamesgolick.com/resource_controller/rdoc/fr_method_index.html").and_return(open(File.dirname(__FILE__) + "/fixtures/jamesgolick.com.html"))
    @rdoc.should_receive(:open).any_number_of_times.with("http://rspec.info/rdoc/fr_method_index.html").and_return(open(File.dirname(__FILE__) + "/fixtures/rspec.info.html"))
    @rdoc.should_receive(:open).any_number_of_times.with("http://rspec.info/rdoc-rails/fr_method_index.html").and_return(open(File.dirname(__FILE__) + "/fixtures/rspec-rdoc-rails.html"))
  end

  it "should be possible to add additional dirs" do
    @rdoc.additional_dirs << "/Users/jon"
    @rdoc.additional_dirs << "/Users/rdoc"
    @rdoc.should have_at_least(2).additional_dirs
  end

  it "should be possible to add website as additional dirs" do
    @rdoc.additional_dirs << "http://api.rubyonrails.com"
    @rdoc.should have_at_least(1).additional_dirs
  end

  it "should have all methods from rdoc method index files in all directores and save it" do
    @rdoc.save
    File.should be_exists(@rdoc.filename)
  end

  it "should search method in the saved yaml file" do
    @rdoc.search("time_ago").found.map{|arr|arr[:method_name]}.should include("time_ago_in_words")
  end

  it "should have the array set for the last search results" do
    @rdoc.found.should be_a_kind_of(Array)
  end

  it "should render search results as html" do
    @rdoc.search("time_ago")
    @rdoc.should be_found
  end

  it "should group search results" do
    @rdoc.search("time_ago")
    @rdoc.found_by_class.should have_key("ActionView::Helpers::DateHelper")
  end
  
  it "should search for class name" do
    @rdoc.search("FileUtils")
    @rdoc.found_by_class.should have_key("FileUtils")
  end
  
  it "should search for class name with namespace" do
    @rdoc.search("ActionView::Helpers::DateHelper")
    @rdoc.found_by_class.should have_key("ActionView::Helpers::DateHelper")
  end  
  
  it "should search after method contains that contin the text" do
    @rdoc.search("ime_ago_in", :contain)
    @rdoc.found_by_class.should have_key("ActionView::Helpers::DateHelper")
  end

  it "should search website for method index" do
    @rdoc.additional_dirs << "http://jamesgolick.com/resource_controller/rdoc/"
    @rdoc.generate_index
    @rdoc.search("smart_url").found.map{|arr|arr[:method_name]}.should include("smart_url")
    @rdoc.save
  end
  
  it "should be able to add new additional dir or site" do
    @rdoc.should_receive(:write_settings_file).and_return(true)
    @rdoc.add("http://www.brynary.com/uploads/webrat/rdoc/")        
  end

end

describe RDoc, "settings" do
  it "should create additional_dirs settings file on initialize" do
    File.should_receive(:exists?).and_return(false)
    File.should_receive(:open).any_number_of_times.and_return(Tempfile.new("rdoc_settings"))
    @rdoc = RDoc.new
  end
end
