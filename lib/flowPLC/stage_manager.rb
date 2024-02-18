# check that a name which given with item is not registerd
class FlowPLC::StageManager
  def initialize
    # @register[item.name] = item
    @register = {}
  end


  # check item's name has not used, and register the name. same ruby's  Set class
  def add?(item)
    if @register.key?(item.name)
      nil
    else
      @register[item.name] = item
    end
  end

  alias :add :add?


  def delete(item)
    if item === String
      @register.delete(item)
    else
      @register.delete(item.name)
    end
  end


  def item_exec(name, command, *args)
    return nil unless @register.key?(name)
    if args.size == 0
      @register[name].method(command).call
    else
      @register[name].method(command).call(args)
    end
  end


  def consist_with_stage(stage_data)
    @register.clear
    stage_data.each do |flow|
      flow.each do |item|
        add(item)
      end
    end
  end


end


