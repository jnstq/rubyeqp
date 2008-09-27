require "rubygems"
require "open-uri"
require "erb"
require "yaml"
require "pp"
require "activesupport"

module ActiveSupport
  class OrderedHash
    def has_key?(key)
      assoc(key)
    end
  end
end

class RDoc
  def additional_dirs
    @additional_dirs ||= YAML.load_file(additional_dirs_filename)
  end
  def add(additional_dir)
    self.additional_dirs << additional_dir unless additional_dirs.include?(additional_dir)
    write_settings_file(additional_dirs)
  end
  def method_index_files
    additional_dirs.map{|path|File.join(path,"fr_method_index.html")}
  end
  def generate_index
    @generate_index ||= method_index_files.inject([]) do |found, file|
      puts "Indexing in #{file}..."
      open(file).each_line do |line|
        res = line.match('<a href="(.*)">(.*)\s\((.*)\)<\/a>')
        if res
          url = "#{"tm-file://" unless file.match(/^http:\/\//)}#{File.dirname(file)}/#{res[1]}"
          found << { :url => url, :method_name => res[2], :class_name => res[3] }
        end
      end
      found
    end
    @generate_index
  end
  def initialize
    write_settings_file(["http://www.ruby-doc.org/core/","http://api.rubyonrails.com/","http://rspec.info/rdoc/", "http://rspec.info/rdoc-rails/"])  unless File.exists?(additional_dirs_filename)
  end
  def additional_dirs_filename
    File.expand_path("~/.rdoc_additional_dirs.yaml")
  end
  def filename
    File.expand_path("~/.rdoc.yaml")
  end
  def load
    @generate_index ||= File.exists?(filename) ? YAML.load_file(filename) : generate_index
  end
  def save
    File.open(filename, "w") { |file| YAML.dump(generate_index, file) }
  end
  def found
    @found ||= []
  end
  def found_by_class
    found.group_by{|arr|arr[:class_name]}
  end
  def found?
    !found.empty?
  end

  ##
  # paramters is the method or class you are searching for
  # options can be :start, :contain and :end with
  # In case of the format is Pascal-case then a search
  # after class name is made insted of method name
  def search(method_name, options = :start)
    load
    @found = generate_index.select do |method|
      (class_name?(method_name) ? method[:class_name] : method[:method_name]) =~ /#{'^' if options == :start}#{Regexp.escape(method_name)}#{'$' if options == :end}/
    end
    self
  end
  def to_html
    if found.size == 1
      puts "<meta http-equiv='Refresh' content='0;URL=#{found.first[:url]}'>"
    else
      ERB.new(File.read(File.dirname(__FILE__) + "/../html/search_results.html.erb")).result(binding)
    end
  end

  private

  def class_name?(name)
    name =~ /^[A-Z]+[a-zA-Z:]+$/
  end

  def write_settings_file(array_of_dirs)
    open(additional_dirs_filename, "w+") do |settings|
      settings.puts "# Ruby Documentation settings\n# Add additional dirs or websites"
      YAML.dump(array_of_dirs, settings)
    end
    array_of_dirs
  end

end
