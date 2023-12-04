require 'curses'
require 'yaml'
require 'singleton'

class Config
  include Singleton

  def initialize
    @doc = YAML.load_file('config.yml')
  end

  def get(name)
    raise "invalid config name #{name}" unless @doc.key?(name)
    @doc[name]
  end
end
