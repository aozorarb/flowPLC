load 'lib/flowPLC.rb'
include FlowPLC

def lp
  load 'lib/flowPLC.rb'
  $p = FlowPLC::Core.new
end

def ip
  $p.new_flow
  $p.push_item(0, 'Input', ['inp'])
end

puts <<~MSG
  Interactive FlowPLC
  Consist by irb.
  type 'lp' to load flowPLC.rb and set $p to Core.new
MSG

