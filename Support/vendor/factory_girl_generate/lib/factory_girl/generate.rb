require 'erb'
class FactoryGirl
  class Generate
    
    def self.render_factory_for(model)
      new.render_factory_for(model)
    end

    def render_factory_for(model)
      model_name = model.name
      columns = model.columns_hash.map {|name, column| [name, value_for(column)] }
      columns.reject! {|name, column| name =~ /_id|updated_at|created_at/ }
      ERB.new(template(:factory), nil, "-").result(binding)
    end
    
    def value_for(column)
      return column.default.inspect if column.default
      return "{ Time.now.to_date }" if column.type == :date
      return "{ Time.now }" if column.type == :datetime
      return 1.inspect if column.number?
      "Value for #{column.name}".inspect
    end
    
    def template(name)
      File.read(File.join(File.dirname(__FILE__), 'templates', "#{name}.erb"))
    end
  end
end