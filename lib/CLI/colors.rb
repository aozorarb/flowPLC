require 'curses'
require_relative 'config_parser'

module CLI;end

module CLI::Colors
  def self.initialize
    colors = CLI::ConfigParser.instance.get['colors']
    @used_number_count = 0
    colors.each do |color|
      Curses.init_color(@used_number_count+1, color[1][0], color[1][1], color[1][2])
      set_const(color[0].capitalize, @used_number_count + 1)
      @used_number_count += 1
    end
  end
end
