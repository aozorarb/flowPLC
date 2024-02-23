require_relative 'flowPLC'

File.open('.interactive_flowPLC_command.rb', 'w') do |file|
  file.puts <<-EOF
  include FlowPLC
  puts <<-MSG
  Interactive FlowPLC
  Consist by irb.
  You should create Core.new (already included FlowPLC)
  MSG
  EOF
end
system('irb -f -r ./flowPLC.rb -r ./.interactive_flowPLC_command.rb')

