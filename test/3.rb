class Manager
  private
  @@items = []

  public
  def add obj
    @@items << obj
  end

  def ls
    puts @@items.join(' ')
  end
end

class Writer
  def initialize
    @mng = Manager.new
  end

  def foo
    (1..10).each { |i| @mng.add i }
  end
end

class Reader
  def initialize
    @mng = Manager.new
  end

  def foo
    @mng.ls
  end
end

writer = Writer.new
writer.foo

reader = Reader.new
reader.foo
