require 'yaml'
require 'singleton'

class ConfigParser
  include 'singleton'

  def initialize
    @config = YAML.load_stream('config.rb')
  rescue
    puts 'missing config.yml'
  end

end
