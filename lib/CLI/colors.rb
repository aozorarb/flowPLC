require 'curses'
require_relative 'config_parser'

module CLI;end

module CLI::Colors
  def self.initialize
    @used_number_count = 1

    background = Curses::COLOR_BLACK
    default_colors = {
      Warning: Curses::COLOR_RED,
    }

    default_colors.each do |def_col|
      Curses.init_pair(@used_number_count, def_col[1], background)
      const_set(def_col[0], Curses.color_pair(@used_number_count))
      @used_number_count += 1
    end
  end

  def self.finalize
    @used_number_count.downto(1) do |num|
      Curses.init_pair(num, Curses::COLOR_BLACK, Curses::COLOR_BLACK)
    end
    @used_number_count = 1
  end
end
