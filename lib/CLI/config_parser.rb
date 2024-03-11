require 'yaml'
require 'curses'
require 'singleton'

class ConfigParser
  include Singleton

  def initialize
    @config = YAML.load_file('CLI/config.yml')
  rescue
    raise 'missing config.yml'
  end

  def get() @config end

  def parse_key(key)
    if String === key
      key = key.upcase
      suffix, str = key.split('-')
      keycode = str.ord
      case suffix
      when 'KEY'
        keycode = Curses::Key.const_get(str)
      when 'C' # control
        keycode = keycode & ~0x40
      when 'S' # shift
        keycode = keycode & ~0x20
      end
      keycode
    else
      key
    end
  end


  def command_parse(commands)
    parsed_commands = {}
    commands.each do |command|
      parsed_commands[parse_key(command[0])] = command[1].to_sym
    end
    parsed_commands
  end


  def commands(key)
    commands = @config[key]
    raise '#{key} is not valid key name' if commands.nil?
    parsed_cmds = command_parse(commands)
  end
end
