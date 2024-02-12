require 'reline'
require_relative 'miniPLC'
# interactive miniPLC like be irb(interactive ruby)

class IminiPLC
  def initialize
    @stty_save = `stty -g`.chomp
    @line_no = 0
  rescue
    raise 'No support Environment'
  end

  def intoroduce
    puts <<-EOS
    Interactive miniPLC
    EOS
  end

  def add_method_completion
    mplc_public_methods = MiniPLC::Core.public_instance_methods
    # public_instance_methods returns symbol
    methods = mplc_public_methods.map(&:to_s)
    Reline.completion_proc = proc { |word| methods }
  end

  def finalize
    `stty #{@stty_save}` if @stty_save != nil
  end

  def input_loop
    while line = Reline.readline("#{format("ImP:%03d", @line_no)}> ", true)
      case line.chomp
      when 'exit', 'quit', 'q'
        exit 0
      when ''
        # NOP
      else
        eval(line) rescue puts $!.split('#')[0]
      end
      @line_no += 1
    end
  end

  def main
    intoroduce
    add_method_completion
    input_loop
  rescue Interrupt
    finalize
  end

end

IminiPLC.new.main
