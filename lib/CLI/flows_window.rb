require 'curses'
require_relative 'config_parser'

module CLI;end

class CLI::FlowsWindow
  def initialize(plc, exec_command)
    @plc = plc
    @exec_command = exec_command
    @win = Curses::Window.new(Curses.lines - 2, 0, 0, 0)
    @win.nodelay = true
    @x = 0
    @y = 0

    load_item_looks
  end

  
  private def resize
    @win.move(0, 0)
    @win.resize(Curses.lines - 2, 0)
  end

  def getch() @win.getch end
  
  def move_cursor() @win.setpos(@x, @y) end


  def draw
    resize
    @win.erase
    @win.setpos(0, 0)
    @win.maxy.times do |line|
      @win.setpos(line, 0)
      @win.addch('|') # start bar
    end
    @win.noutrefresh
  end
  

  private def load_item_looks
    @item_looks =  {}
    items_looks = CLI::ConfigParser.instance.get['item_looks']
    items_looks.each do |item_looks|
      @item_looks["FlowPLC::Item::#{item_looks[0]}".to_sym] = item_looks[1]
    end
  end

  
  # ex: (X100)
  # -> [first_line, second_line]
  private def make_item_looks(item, size: 5)
    raise 'size must be bigger than 3' if size <= 3
    ret = Array.new(2)
    ret[0] = item.name[0, size].center(size)
    # if this execution is slow, change hash key to symbol
    item_symbol = item.to_s.to_sym
    o_bracket = @item_looks[item_symbol]['open-bracket'].to_s
    c_bracket = @item_looks[item_symbol]['close-bracket'].to_s
    contents = @item_looks[item_symbol]['contents'].to_s
    ret[1] = "#{o_bracket}#{contents.center(size-2)}#{c_bracket}"
    ret
  end
end

