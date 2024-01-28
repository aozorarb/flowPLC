# 'flow' indicates flow line
# method prefixed '_' helps  method with the same name without '_'
# mainly recursion method

class Stage
  attr_accessor :data

  def initialize
    @data = []
  end

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

  def show_class
    @data.each do |dt|
      _show_class(dt)
    end
  end

  def _show_class(data)
    # if not nest, not flow
    if data.class == Array && data.class[0] == Array
      data.each { |dt| _show_class(dt) }
    else
      pp data.map { |dt| dt.class }
    end
  end

  alias :show :show_class

  def show_detail
    pp @data
  end
end
