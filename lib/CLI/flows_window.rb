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
    cur_x, cur_y = 0, 0
    flow_count = 0
    flow_size = @plc.stage.data.size
    if cur_y < @win.maxy && flow_count < flow_size
      draw_bar
      @plc.stage.data[flow_count].each do |item|
        draw_hypen
        draw_item(item)
        break if @win.curx > @win.maxx
      end
      flow_count += 1
    end
    @win.noutrefresh
  end
  

  private def load_item_looks
    @item_looks =  {}
    @item_size = CLI::ConfigParser.instance.get['item-size']
    @item_size = 5 unless @item_size >= 3
    items_looks = CLI::ConfigParser.instance.get['item-looks']
    items_looks.each do |item_looks|
      @item_looks["FlowPLC::Item::#{item_looks[0]}".to_sym] = item_looks[1]
    end
  end

  
  # ex: (X100)
  # -> Array [first_line, second_line]
  private def make_item_looks(item)
    ret = Array.new(2)
    ret[0] = item.name[0, size].center(@size)
    # if this execution is slow, change hash key to symbol
    item_symbol = item.to_s.to_sym
    o_bracket = @item_looks[item_symbol]['open-bracket'].to_s
    c_bracket = @item_looks[item_symbol]['close-bracket'].to_s
    contents = @item_looks[item_symbol]['contents'].to_s
    ret[1] = "#{o_bracket}#{contents.center(@size-2)}#{c_bracket}"
    ret
  end


  private def draw_item(item)
    first_line, second_line = make_item_looks(item)
    return nil if @x + @item_size >= @win.maxx || @y + 2 >= @winn.maxy
    @win.addstr(first_line)
    @win.setpos(@y + 1, @x)
    @win.addstr(second_line)
    @win.setpos(@y, @x + @item_size)
  end


  private def draw_bar
    @win.addch('|')
  end


  private def draw_hypen
    unless @win.inch == '-'
      @win.addch('-')
    end
  end


end

