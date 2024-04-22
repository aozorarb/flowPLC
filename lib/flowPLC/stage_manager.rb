# check that a name which given with item is not registerd
class FlowPLC::StageManager

  ItemHolder = Struct.new(:item, :count)

  def initialize
    # @register[item.name] = item
    @register = {}
  end


  def add(item)
    raise "not item: #{item}" unless item.kind_of?(FlowPLC::Item::BasicItem)
    if @register.key?(item.name)
      @register[item.name].count += 1
    else
      @register[item.name] = ItemHolder.new(item, 1)
    end
  end



  def delete(item)
    item_name = (String === item ? item : item.name)
    if @register.key?(item_name)
      ret = @register[item_name].count -= 1
      @register.delete(item_name) if @register[item_name].count == 0
      ret
    else
      nil
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
    raise "Underfind method #{command} for #{name}"
  end


  def consist_with_stage(stage_data)
    @register.clear
    stage_data.each do |flow|
      flow.each do |item|
        add(item)
      end
    end
  end

  private def test_mode
    attr_accessor :register
  end
end
