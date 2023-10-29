require_relative 'items.rb'
class Stage
  private
  @lines

  public

  attr :lines

  def initialize
    @lines = [[Item::Start.new, Item::End.new]]
  end

  def new_line
    @lines << []
  end

  def delete_line(y)
    @lines.delete_at(y)
  end

  def push_back(y, item)
    if @lines.size > y
      raise
    else
      @lines[y] << item
    end
  end

  def size
    @lines.size
  end

end
