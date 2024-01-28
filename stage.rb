class Stage
  attr_accessor :data

  def initialize
    @data = []
  end
# 'flow' indicates flow line

# push to already exists flow
  def push(idx, item)
    @data[idx] << item
  end

# insert to already exists flow
  def insert(flow_idx, inflow_idx, item)
    @data[flow_idx].insert(inflow_idx, item)
  end
# make new flow
  def new_flow(item)
    @data << [item]
  end
end
