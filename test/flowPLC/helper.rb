require_relative '../../lib/flowPLC.rb'

class FlowPLC::Item::BasicItem

  attr_accessor :name, :state
  
  def ==(other)
    # judge by inner item. No object_id
    vars = self.instance_variables
    vars.all? {|v| self.instance_variable_get(v) == other.instance_variable_get(v) }
  end
end

