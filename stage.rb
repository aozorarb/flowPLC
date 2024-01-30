# 'flow' indicates flow line
# method prefixed '_' helps  method with the same name without '_'
# mainly recursion method

class Stage
  attr_reader :data

  def initialize
    @data = []
  end

  def flow_number
    @data.size
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

  def delete_flow(idx)
    @data.delete_at(idx)
  end

  def delete_at(flow_idx, inflow_idx)
    @data[flow_idx].delete_at(inflow_idx)
  end

  # show only class name
  def show_class
    puts
    puts "stage:"
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
    puts
    puts "stage:"
    pp @data
  end
end
