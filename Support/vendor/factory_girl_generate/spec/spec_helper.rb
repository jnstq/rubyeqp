this_dir = File.dirname(__FILE__)
$LOAD_PATH << File.expand_path(File.join(this_dir, "..", "lib"))

require "rubygems"
require "spec"
require "active_record"
require "factory_girl/generate"

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.string :username, :password
    t.integer :number
  end
  create_table :posts, :force => true do |t|
    t.text :body
    t.date :starts_on
    t.timestamps
  end
end

class Post < ActiveRecord::Base
end

class User < ActiveRecord::Base
end