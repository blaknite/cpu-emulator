require 'io/console'
require 'io/wait'

class Terminal
  def initialize
    @rx = Computer::REGISTER[0xe]
    @tx = Computer::REGISTER[0xf]
  end

  def clock!
    putc @tx.value unless @tx.empty?
    if $stdin.ready?
      char = $stdin.getc
      @rx.value = char.bytes.first if char
      exit if char == "\u0003"
    end
  end

  def reset!
    @rx.reset!
    @tx.reset!
  end

  def init
    system("stty -icanon -echo")
    ansi_cmd('?25l')
  end

  def close
    system("stty icanon echo")
    ansi_cmd('?25h')
  end

  private

  def ansi_cmd(cmd)
    $stdout.putc(0x1B)
    $stdout.putc('[')
    $stdout.print(cmd)
  end
end
