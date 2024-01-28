module Item
  class Input
    attr_accessor :state
    def initialize
      @state = false
    end
  end

  class Timer
    attr_reader :state
    attr_accessor :time
    def initialize
      @time = 0
      @progress = 0
      @state = false
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

