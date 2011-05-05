module Quack #both a stack and a queue
  def quack
    @quack ||= []
  end

  def add(char)
    quack.push(char)
  end

  def top_two
    return false if quack.length < 2
    quack.at(-2) + quack.at(-1)
  end

  def ready
    quack.length > 2
  end

  def get_first
    quack.shift
  end

  def length
    quack.length
  end

  def clear
    quack.clear
    nil
  end

end

class Manager
  include Quack
  
  attr_reader :comment

  def initialize
    @comment = false
  end

  def comment_start
    top_two == '/*'
  end

  def comment_end
    top_two == '*/'
  end

  def process(char)
    add(char)
    @comment = true if comment_start
    @comment = false if comment_end
    c = filter
    c unless c.nil?
  end

  def filter
    return get_first if ready and comment_start #["c", "/", "*"] - pop "c"
    clear if comment_end #["*", "/"]
    get_first if ready and !comment #["a", "b", "c"] or ["b", "c", "/"]
  end
end