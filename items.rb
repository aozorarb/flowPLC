module Items
  class Timer
    def initialize(delay)
      @delay = delay
      @progress = 0
    end

    # if input is not, progress reset.
    def execute(cond)
      if cond
        @progress += 1
      else
        @progress = 0
      end
      return (@delay <= @progress ? true : false)
    end
  end
end

