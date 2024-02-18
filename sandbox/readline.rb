require 'readline'

# コマンド履歴の保存ファイル
HISTORY_FILE = File.expand_path('~/.ruby_history')

# 補完候補のリスト
COMPLETEION_WORDS = ['puts', 'print', 'p', 'exit', 'quit', 'help', 'hello', 'world']

# 補完の設定
Readline.completion_proc = ->(input) do
  COMPLETEION_WORDS.grep(/^#{Regexp.escape(input)}/)
end

# コマンド履歴の設定
if File.exist?(HISTORY_FILE)
  lines = File.readlines(HISTORY_FILE).map(&:chomp)
  Readline::HISTORY.push(*lines)
end

# IRBのような対話的なループ
loop do
  input = Readline.readline('irb> ', true)
  break if input.nil? || input.strip.downcase == 'exit' || input.strip.downcase == 'quit'

  if input.strip.downcase == 'help'
    puts 'Available commands: ' + COMPLETION_WORDS.join(', ')
  else
    puts "=> #{eval(input).inspect}"
  end

  # 入力をコマンド履歴に追加
  Readline::HISTORY.push(input)

  # コマンド履歴の保存
  File.write(HISTORY_FILE, Readline::HISTORY.to_a.join("\n"))
end
