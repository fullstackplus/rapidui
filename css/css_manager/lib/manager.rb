class Manager
  
  attr_reader :comment

  def initialize
    @queue = []
    @comment = false
  end

  def get_first
    @queue.shift
  end

  def process(char)
    @queue.push(char)
    set_state
    c = filter
    c unless c.nil?
  end

  private
  
  def top_two
    return false if @queue.length < 2
    @queue.at(-2) + @queue.at(-1)
  end

  def comment_start
    top_two == '/*'
  end

  def comment_end
    top_two == '*/'
  end

  def ready
    @queue.length > 2
  end
  
  def clear
    @queue.clear
    nil
  end

  def set_state
    @comment = true if comment_start
    @comment = false if comment_end
  end

  def filter
    return get_first if ready and comment_start #queue = ["c", "/", "*"] - pop "c"
    clear if comment_end #queue = ["/", "*",  "c", "o", "m", "m", "e", "n", "t", "*", "/"]
    get_first if ready and !comment #queue = ["a", "b", "c"] or ["b", "c", "/"]
  end
end