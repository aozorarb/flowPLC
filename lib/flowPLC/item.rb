module FlowPLC;end

module FlowPLC::Item
  # Item's superclass is always BasicItem
  class BasicItem
    attr_reader :name, :state

    def initialize(name, *args)
      @name = name.to_sym
      @state = false
      class_initialize(*args)
    end
    

    private def class_initialize
      # edit by children
    end

  end


  class Input < BasicItem
    def on() @state = true end
    def off() @state = false end
  end


  class Output < BasicItem
    # The reason for not using names such as 'on' and 'off' is
    # to emphasise that they cannot be manipulated by the user.
    def enable() @state = true end
    def disable() @state = false end
  end


  class Timer < BasicItem
    attr_reader :time

    def class_initialize(time)
      @time = time
      @progress = 0
      @running = false
    end


    def start() @running = true end
    def stop()  @running = false end


    def reset
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

