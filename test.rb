class VirtualPLC
  def initialize
    @digital_inputs = Array.new(8, false)
    @digital_outputs = Array.new(8, false)
    @timers = Array.new(4) { Timer.new }
  end

  def set_digital_input(index, value)
    validate_index(index)
    @digital_inputs[index] = value
  end

  def get_digital_input(index)
    validate_index(index)
    @digital_inputs[index]
  end

  def set_digital_output(index, value)
    validate_index(index)
    @digital_outputs[index] = value
  end

  def get_digital_output(index)
    validate_index(index)
    @digital_outputs[index]
  end

  def start_timer(timer_index, duration)
    validate_timer_index(timer_index)
    @timers[timer_index].start(duration)
  end

  def check_timers
    @timers.each_with_index do |timer, index|
      if timer.running? && timer.expired?
        set_digital_output(index, true)
        timer.stop
      else
        set_digital_output(index, false)
      end
    end
  end

  private

  def validate_index(index)
    raise ArgumentError, 'Index out of range' unless (0...8).cover?(index)
  end

  def validate_timer_index(timer_index)
    raise ArgumentError, 'Timer index out of range' unless (0...4).cover?(timer_index)
  end
end

class Timer
  attr_reader :start_time, :duration

  def initialize
    @start_time = nil
    @duration = nil
  end

  def start(duration)
    @start_time = Time.now
    @duration = duration
  end

  def running?
    !@start_time.nil?
  end

  def expired?
    running? && (Time.now - @start_time) >= @duration
  end

  def stop
    @start_time = nil
    @duration = nil
  end
end

# 仮想PLCのインスタンスを作成
plc = VirtualPLC.new

# タイマーをスタートさせる（タイマー0, 2秒）
plc.start_timer(0, 2)

# タイマーをスタートさせる（タイマー1, 5秒）
plc.start_timer(1, 6)

# 1秒ごとにタイマーをチェックし、経過したらデジタル出力を設定
10.times do
  sleep 1
  plc.check_timers
  puts "Digital Outputs: #{plc.get_digital_output(0)}, #{plc.get_digital_output(1)}"
end
