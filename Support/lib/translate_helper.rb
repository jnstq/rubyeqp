class TranslateHelper
  attr_accessor :locale, :data
  def initialize(locale)
    @locale = locale
  end
  def add_translation(key, value = 'untranslated')
    load_data
    build_from_key_chain_and_set_value(key, value)
    save_data
  end
  def keys_for(translation)
    load_data
    search(translation)
  end
  def self.locales
    Dir["#{locale_path}/*.yml"].map do |filename|
      File.basename(filename,'.yml')
    end.uniq.sort
  end
  def self.locale_path
    fail_unless_project_directory
    File.join(ENV['TM_PROJECT_DIRECTORY'],'config', 'locales', 'site')
  end
  def self.keys_for(translation)
    fail_unless_project_directory
    locales.map do |locale|
      TranslateHelper.new(locale).keys_for(translation)
    end.compact
  end
  private
  def load_data
    @data = File.open("#{locale_path}/#{@locale}.yml") {|f| YAML::load(f) }
  end
  def save_data
    File.open("#{locale_path}/#{@locale}.yml", "w") { |f| YAML.dump(@data, f) }
  end
  def locale_path
    self.class.locale_path
  end
  def build_from_key_chain_and_set_value(keys, value)
    keys = "#{locale}.#{keys}".split('.')
    data = keys[0..-2].inject(@data) do |r, k|
      r[k] ||= {}
      r[k]
    end
    data[keys.last] = value
  end
  def search(value)
    @found_keys = []
    deep_search(@data, value)
    @found_keys.flatten!
    @found_keys unless @found_keys.empty?
  end
  def deep_search(h, value, trail=[])
    h.each_pair do |k, v|
      if v == value
        @found_keys << [trail,k].flatten
      elsif v.is_a?(Hash)
        deep_search(v, value, [trail, k].flatten)
      end
    end
    @found_keys
  end
  def self.fail_unless_project_directory
    fail 'Unknown project directory' unless ENV['TM_PROJECT_DIRECTORY']
  end
end
