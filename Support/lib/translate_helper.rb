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
  def self.locales
    Dir["#{locale_path}/*.yml"].map do |filename|
      File.basename(filename,'.yml')
    end.uniq.sort
  end
  def self.locale_path
    fail 'Unknown project directory' unless ENV['TM_PROJECT_DIRECTORY']    
    File.join(ENV['TM_PROJECT_DIRECTORY'],'config', 'locales', 'site')
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
end