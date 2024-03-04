require_relative 'flowPLC'

File.open('.interactive_flowPLC_command.rb', 'w') do |file|
  file.puts <<~EOF
include FlowPLC

def lp
  load 'flowPLC.rb'
  $p = Core.new
end

def ip
  $p.new_flow(0)
  $p.push_item(0, Item::Input.new('A'))
end

puts <<-MSG
Interactive FlowPLC
Consist by irb.
type 'lp' to load flowPLC.rb and set $p to Core.new
MSG
  EOF
end
system('irb -f -r ./flowPLC.rb -r ./.interactive_flowPLC_command.rb')

