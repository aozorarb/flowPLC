require_relative 'stage_manager'

# 'flow' indicates flow line
# method prefixed '_' helps  method with the same name without '_'
# mainly recursion method

module FlowPLC; end

class FlowPLC::Stage

  attr_reader :data, :flow_state
  # data is flows union
  # flow_state is each item's state of each flows


  def initialize
    @data = []
    @flow_state = []
    @manager = FlowPLC::StageManager.new
  end


  private def name2item_class(item_class_name, item_args)
    item_class = Object.const_get("FlowPLC::Item::#{item_class_name}")
    item_class.new(*item_args)
  rescue NameError
    raise NameError, "Not item name: #{item_class_name}"
  end


  def item_exec(name, command)
    @manager.item_exec(name.to_sym, command)
  rescue UnusableNameError
    "Invalid name: #{name}" 
  rescue NoMethodError
    "Not Method: #{command}"
  end


  # push item to already exist flow
  def push_item(flow_idx, item, item_args)
    item = name2item_class(item, item_args)
    flow_idx = flow_idx.to_i
    return nil if @data[flow_idx].nil?
    @manager.add(item)
    @data[flow_idx] << item
    @flow_state[flow_idx] << false
    true
  end


  # insert item to already exist flow
  def insert_item(flow_idx, inflow_idx, item, item_args)
    flow_idx = flow_idx.to_i
    inflow_idx = inflow_idx.to_i
    item = name2item_class(item, item_args)
    return nil if @data[flow_idx].nil? || inflow_idx > @data[flow_idx].size
    @manager.add(item)
    @data[flow_idx].insert(inflow_idx, item)
    @flow_state[flow_idx].insert(inflow_idx, false)
    true
  end


  # make new flow
  def new_flow
    @data << []
    @flow_state << []
  end


  def new_flow_at(flow_idx)
    flow_idx = flow_idx.to_i
    return nil if flow_idx > @data.size
    @data.insert(flow_idx, [])
    @flow_state.insert(flow_idx, [])
    true
  end


  def delete_flow(flow_idx)
    flow_idx = flow_idx.to_i
    return nil if @data[flow_idx].nil?
    @data[flow_idx].each do |dt|
      @manager.delete(dt)
    end
    @flow_state.delete_at(flow_idx)
    @data.delete_at(flow_idx)
  end


  def delete_item(item_name)
    @manager.delete(item_name)
    @data.delete(item_name)
  end


  def delete_item_at(flow_idx, inflow_idx)
    flow_idx = flow_idx.to_i
    inflow_idx = inflow_idx.to_i
    return nil unless flow_idx < @data.size && inflow_idx < @data[flow_idx].size
    @manager.delete(@data[flow_idx][inflow_idx])
    @flow_state[flow_idx].delete_at(inflow_idx)
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


  def consist_with_data_file(data)
    if data.nil?
      return nil
    else
      @data = data
      @manager.consist_with_stage(@data)
    end
  end

end
