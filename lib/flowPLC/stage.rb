require_relative 'stage_manager'
# load 'flowPLC/stage_manager.rb'

# 'flow' indicates flow line
# method prefixed '_' helps  method with the same name without '_'
# mainly recursion method

module FlowPLC
  class UnusableNameError < Exception;end

  class Stage

    attr_reader :data
    # data is flows union
    # flow_state is each item's state of each flows


    def initialize
      @data = []
      @flow_state = []
      @manager = FlowPLC::StageManager.new
    end


    def item_exec(name, command)
      raise UnusableNameError, "Invalid name: #{name}" if @manager.item_exec(name.to_sym, command).nil?
    end


    # push item to already exist flow
    def push_item(flow_idx, item)
      return nil if @data[flow_idx].nil?
      @manager.add(item)
      @data[flow_idx] << item
      @flow_state[flow_idx] << false
      true
    end


    # insert item to already exist flow
    def insert_item(flow_idx, inflow_idx, item)
      return nil if @data[flow_idx].nil? || inflow_idx > @data[flow_idx].size
      @manager.add(item)
      @data[flow_idx].insert(inflow_idx, item)
      @flow_state[flow_idx].insert(inflow_idx, false)
      true
    end


    # make new flow
    def new_flow(flow_idx)
      return nil if flow_idx > @data.size
      @data.insert(flow_idx, [])
      @flow_state.insert(flow_idx, [])
      true
    end


    def delete_flow(flow_idx)
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
      return nil unless flow_idx < @data.size && inflow_idx < @data[flow_idx].size
      @manager.delete(@data[flow_idx][inflow_idx])
      @flow_state[flow_idx].delete_at(inflow_idx)
      @data[flow_idx].delete_at(inflow_idx)
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


    private def test_mode
      attr_accessor :manager, :flow_state
      @manager.send(:test_mode)
    end
  end
end
