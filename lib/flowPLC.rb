require_relative 'flowPLC/item'
require_relative 'flowPLC/stage'
require_relative 'flowPLC/data_file'
#load 'flowPLC/item.rb'
#load 'flowPLC/stage.rb'
#load 'flowPLC/data_file.rb'

module FlowPLC
  class Core
    def initialize
      @stage = FlowPLC::Stage.new
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

    # item execute if previous item's state is true
    private def run_enable_item(item)
      include FlowPLC
      case item
      when Item::Output
        item.enable
      when Item::Timer
        item.start
        item.run
      end
    end


    # when previous item's state is false
    private def run_disable_item(item)
      include FlowPLC
      case item
      when Item::Output
        item.disable
      when Item::Timer
        # timer require constant input until count up
        item.reset
      end
    end


    def run
      @stage.data.each_with_index do |flow, flow_idx|
        flow.each_with_index do |item, inflow_idx|
          # item execute if previous item's state is true
          # first item always execute
          if inflow_idx == 0
            run_enable_item(item)
          else
            if @stage.flow_state[flow_idx][inflow_idx-1]
              run_item(item)
            else
              run_disable_item(item)
            end
          end
          # item refresh after it ran
          @stage.flow_state[flow_idx][inflow_idx] = item.state
        end
      end
    end


    def puts_state
      @stage.show_class
      @stage.show_state
    end


    def puts_state_deep
      @stage.show_detail
      @stage.show_state
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


    def item_exec(name, command)
      @stage.item_exec(name, command)
    rescue UnusableNameError
      warn "#{name} is not usable"
    end


  end
end
