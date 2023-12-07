require_relative 'items.rb'
class Stage
  private
  @lines

  public

  attr :lines

  def initialize
    @lines = [
      [Item::Output.new(0x10)],
    ]
  end

  def new_line
    @lines << []
  end

  def delete_line(y)
    @lines.delete_at(y)
  end

  def insert(y, item)
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
