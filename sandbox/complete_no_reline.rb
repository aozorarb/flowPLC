module Completer
  @completion_words  = []
  attr_accessor :completion_words
  def self.complete(word)
    match_words = completion_words
  end
  
end
