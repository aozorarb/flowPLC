# check that a name which given with item is not registerd
module FlowPLC; end

class FlowPLC::StageManager

  ItemHolder = Struct.new(:item, :amount)

  def initialize
    # @register[item.name] = item
    @register = {}
  end


  def add(item)
    raise FlowPLC::NotItemError ,"not item: #{item}" unless item.kind_of?(FlowPLC::Item::BasicItem)
    if @register.key?(item.name)
      @register[item.name].amount += 1
    else
      @register[item.name] = ItemHolder.new(item, 1)
    end
  end



  def delete(item)
    item_name = (String === item ? item : item.name)
    if @register.key?(item_name)
      ret = @register[item_name].amount -= 1
      @register.delete(item_name) if @register[item_name].amount == 0
      ret
    else
      nil
    end
  end

end
