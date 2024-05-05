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
    def push_item(flow_idx, item)               @stage.push_item(flow_idx, item) end
    def insert_item(flow_idx, inflow_idx, item) @stage.insert_item(flow_idx, inflow_idx, item) end
    def new_flow_at(flow_idx)                   @stage.new_flow_at(flow_idx) end
    def new_flow()                              @stage.new_flow end
    def delete_flow(flow_idx)                   @stage.delete_flow(flow_idx) end
    def delete_item_at(flow_idx, inflow_idx)    @stage.delete_item_at(flow_idx, inflow_idx) end
    def item_name_at(flow_idx, inflow_idx)      @stage[flow_idx][inflow_idx].name end
    def delete_item(name)                       @stage.delete_item(name) end


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
    

    def item_exec(name, command)
      FlowPLC::ItemExecute.item_exec(name, command)
    end


    def save(filename)
      DataFile.save(@stage, filename)
      true
    rescue
      warn "'#{filename}' is already used name"
      false
    end


    def save!(filename)
      DataFile.save(@stage, filename, overwrite: true)
      true
    rescue
      warn "'#{filename}' is not usable"
      false
    end


    def load(file_name)
      data = DataFile.load(file_name)
      @stage.consist_with_data_file(data)
      true
    rescue
      warn "'#{filename}' is not found"
      false
    end

  end
end
