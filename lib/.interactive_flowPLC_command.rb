  include FlowPLC

  def lp
    load 'flowPLC.rb'
    $p = Core.new
  end
  puts <<-MSG
  Interactive FlowPLC
  Consist by irb.
  type 'lp' to load flowPLC.rb and set $p to Core.new
  MSG
