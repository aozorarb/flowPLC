require_relative 'flowPLC/stage'
require_relative 'flowPLC/data_file'
require_relative 'flowPLC/item_execute'

module FlowPLC
  class Core

    def initialize
      @stage = FlowPLC::Stage.new
      FlowPLC::ItemExecute.stage = @stage
    end
    attr_reader :stage

    # access Stage methods
    def push_item(flow_idx, item, item_args)               @stage.push_item(flow_idx, item, item_args) end
    def insert_item(flow_idx, inflow_idx, item, item_args) @stage.insert_item(flow_idx, inflow_idx, item, item_args) end
    def new_flow_at(flow_idx)                              @stage.new_flow_at(flow_idx) end
    def new_flow()                                         @stage.new_flow end
    def delete_flow(flow_idx)                              @stage.delete_flow(flow_idx) end
    def delete_item_at(flow_idx, inflow_idx)               @stage.delete_item_at(flow_idx, inflow_idx) end
    def item_name_at(flow_idx, inflow_idx)                 @stage[flow_idx][inflow_idx].name end


    def puts_state
      @stage.show_class
      @stage.show_state
    end


    def puts_state_deep
      @stage.show_detail
      @stage.show_state
    end


    def run
      FlowPLC::ItemExecute.run
    end
    

    def item_exec(flow_idx, inflow_idx, command, *args)
      FlowPLC::ItemExecute.item_exec(flow_idx, inflow_idx, command, args)
    end


    def save(filename)
      DataFile.save(@stage, filename)
      true
    rescue
      false
    end


    def save!(filename)
      DataFile.save(@stage, filename, overwrite: true)
      true
    rescue
      false
    end


    def load(filename)
      data = DataFile.load(filename)
      @stage.consist_with_data_file(data)
      true
    #rescue
    #  warn "'#{filename}' is not found"
    #  false
    end

  end
end
