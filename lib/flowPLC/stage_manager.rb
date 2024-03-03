# check that a name which given with item is not registerd
class FlowPLC::StageManager
  def initialize
    # @register[item.name] = item
    @register = {}
  end


  # check item's name has not used, and register the name.
  def add?(item)
    # TODO: refer item include FlowPLC::Item (but the method is not ready)
    raise "not item: #{item}" unless item.kind_of?(FlowPLC::Item::BasicItem)
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
  rescue
    raise 'Underfind method #{command} for #{name}'
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


