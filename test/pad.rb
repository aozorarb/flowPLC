require 'curses'
include Curses
init_screen
N = 1000
pad = Pad.new(N, 10)
x, y = 0, 0
N.times do |i|
  pad.addstr i.to_s
  pad.setpos(i, 0)
end

pad.setpos(0, 0)
pad.refresh(y, x, 0, 0, lines-1, cols-1)

while true
  ch = pad.getch
  case ch
  when 'h'
    x -= 1
  when 'j'
    y += 1
  when 'k'
    y -= 1
  when 'l'
    x += 1
  end
  x = x.clamp(0, cols-1)
  y = y.clamp(0, N-1)
  pad.refresh(y, x, 0, 0, lines-1, cols-1)
end
at_exit do
  Curses.close_screen
end

