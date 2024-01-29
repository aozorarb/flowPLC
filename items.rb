module Item
  class BasicItem
    attr_reader :name, :state

    def initialize(name)
      @name = name
      @state = false
      class_initialize
    end
    
    def class_initialize
      # edit by children
    end
  end

  class Input < BasicItem
    def toggle() @state = !@state end
    def on() @state = true end
    def off() @state = false end
  end

  class Timer
    attr_reader :time
    def class_initialize(time)
      @time = time
      @progress = 0
      @running = false
    end


    def start() @running = true end
    def stop()  @running = false end
    def reset_start
      @progress = 0
      @state = false
      @running = true
    end

    def reset_stop
      @progress = 0
      @state = false
      @running = false
    end

    def run
      @progress += 1 if @running
      if @progress >= @time
        stop
        @state = true
      end
    end
  end
end

