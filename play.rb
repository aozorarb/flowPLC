require_relative 'PLC.rb'
# play freely!
plc = PLC.new
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.push(0, Item::Output.new('out01'))

plc.puts_state
10.times { plc.run }
plc.puts_state
