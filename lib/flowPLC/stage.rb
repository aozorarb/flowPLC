# 'flow' indicates flow line
# method prefixed '_' helps  method with the same name without '_'
# mainly recursion method

module FlowPLC; end

class FlowPLC::Stage

  attr_reader :data
  # data is flows union

  def initialize
    @data = []
    @manager = FlowPLC::StageManager.new
  end


  private def name2item_class(item_class_name, item_args)
    item_class = Object.const_get("FlowPLC::Item::#{item_class_name}")
    item_class.new(*item_args)
  rescue NameError
    raise FlowPLC::NotItemError, "Not item name: #{item_class_name}"
  end


  private def valid_index?(*indexies)
    case indexies.size
    when 1
      !@data[indexies[0]].nil? || indexies[0] == 0
    when 2
      (!@data[indexies[0]].nil?) && indexies[1].between?(0, @data[indexies[0]].size)
    else
      raise ArgumentError, 'Given size of indexies must be 1 or 2'
    end
  end


  def item_exec(flow_idx, inflow_idx, command, *args)
    flow_idx = flow_idx.to_i
    inflow_idx = inflow_idx.to_i
    raise FlowPLC::InvalidIndex unless valid_index?(flow_idx, inflow_idx)

    if args.size == 0
      @data[flow_idx][inflow_idx].method(command).call
    else
      @data[flow_idx][inflow_idx].method(command).call(*args)
    end
  end


  # push item to already exist flow
  def push_item(flow_idx, item, item_args)
    item = name2item_class(item, item_args)
    flow_idx = flow_idx.to_i
    return nil unless valid_index?(flow_idx)

    @manager.add(item)
    @data[flow_idx] << item
    @data
  end


  # insert item to already exist flow
  def insert_item(flow_idx, inflow_idx, item, item_args)
    flow_idx = flow_idx.to_i
    inflow_idx = inflow_idx.to_i
    item = name2item_class(item, item_args)
    return nil unless valid_index?(flow_idx, inflow_idx)

    @manager.add(item)
    @data[flow_idx].insert(inflow_idx, item)
    @data
  end


  # make new flow
  def new_flow
    @data << []
  end


  def new_flow_at(flow_idx)
    flow_idx = flow_idx.to_i
    return nil unless valid_index?(flow_idx)

    @data.insert(flow_idx, [])
    @data
  end


  def delete_flow(flow_idx)
    flow_idx = flow_idx.to_i
    return nil unless valid_index?(flow_idx)

    @data[flow_idx].each do |dt|
      @manager.delete(dt)
    end
    @data.delete_at(flow_idx)
  end


  def delete_item_at(flow_idx, inflow_idx)
    flow_idx = flow_idx.to_i
    inflow_idx = inflow_idx.to_i
    return nil unless valid_index?(flow_idx, inflow_idx)

    @manager.delete(@data[flow_idx][inflow_idx])
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


  private def _show_class(data)
    # data is array and data.first is flow
    if Array === data && Array === data.first
      data.each {|dt| _show_class(dt) }
    else
      pp data.map {|dt| dt.class }
    end
  end


  def show_detail
    puts
    puts "stage:"
    pp @data
  end


  def consist_with_data_file(stage_data)
    if data.nil?
      return nil
    else
      @data = stage_data.data
      @manager = stage_data.instance_variable_get(:@manager)
    end
  end

end
