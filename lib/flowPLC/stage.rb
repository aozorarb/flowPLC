require_relative 'stage_manager'
# 'flow' indicates flow line
# method prefixed '_' helps  method with the same name without '_'
# mainly recursion method

class FlowPLC::Stage

  attr_reader :data, :flow_state
  # data is flows union
  # flow_state is each item's state of each flows


  def initialize
    @data = []
    @flow_state = []
    @manager = FlowPLC::StageManager.new
  end


  def flow_number
    @data.size
  end


  def raise_used_name(item)
    raise ArgumentError, "Already used item's name: #{item.name}"
  end


  def manager_add(item)
    raise_used_name(item) if @manager.add?(item).nil?
  end


  def item_exec(name, command)
    raise ArgumentError, "Invalid name: #{name}" if @manager.item_exec(name.to_sym, command) == nil
  end


  # push to already exist flow
  def push(idx, item)
    manager_add(item)
    @data[idx] << item
    @flow_state[idx] << false
  end


  # insert to already exist flow
  def insert(flow_idx, inflow_idx, item)
    manager_add(item)
    @data[flow_idx].insert(inflow_idx, item)
    @flow_state[flow_idx].insert(inflow_idx, false)
  end


  # make new flow
  def new_flow(item)
    manager_add(item)
    @data << [item]
    @flow_state << [false]
  end


  def delete_flow(idx)
    @data[idx].each do |dt|
      @manager.delete(dt)
    end
    @data.delete_at(idx)
    @flow_state.delete_at(idx)
  end


  def delete_at(flow_idx, inflow_idx)
    @manager.delete(@data[flow_idx][inflow_idx])
    @data[flow_idx].delete_at(inflow_idx)
    @flow_state[flow_idx].delete_at(inflow_idx)
  end


  def show_state
    pp @flow_state
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


  def show_detail
    puts
    puts "stage:"
    pp @data
  end


  def consist_with_data_file(data)
    if data == nil
      return nil
    else
      @data = data
      @manager.consist_with_stage(@data)
    end
  end

end

