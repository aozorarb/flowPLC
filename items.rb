module Item
  class BasicItem
    attr_reader :name, :state

    def initialize(name, *args)
      @name = name
      @state = false
      class_initialize(args)
    end
    
    def class_initialize(args)
      # edit by children
      # arg is array
    end

    def check_argments(arguments, expected_number)
      raise ArgumentError, "#{self.name}: expected #{expected_number} given #{arguments.size}" unless arguments.size == expected_number
    end

    private :check_argments, :class_initialize

  end


  class Input < BasicItem
    def toggle() @state = !@state end
    def on() @state = true end
    def off() @state = false end
  end


  class Timer < BasicItem
    attr_reader :time
    def class_initialize(arg)
      check_argments(arg, 1)
      @time = arg[0]
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

