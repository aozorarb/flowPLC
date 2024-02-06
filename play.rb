require_relative 'PLC.rb'
plc = PLC.new

#debug
DStage = plc.instance_variable_get('@stage')
DStageManager = Stage.instance_variable_get('@manager')

# play freely!
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.push(0, Item::Output.new('out01'))

plc.input_turn_on('in01')

plc.puts_state
10.times { plc.run }
plc.puts_state

plc.save!('test.yml')


