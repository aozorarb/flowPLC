require_relative 'PLC.rb'
plc = PLC.new

#debug
Stage = plc.instance_variable_get('@stage')
StageManager = Stage.instance_variable_get('@manager')

# play freely!
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.push(0, Item::Output.new('out01'))

plc.input_turn_on('in01')

pp StageManager
plc.puts_state
1.times { plc.run }
plc.puts_state



