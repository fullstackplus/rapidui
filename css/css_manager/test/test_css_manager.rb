require './lib/manager.rb'

class TestableManager < Manager
  #This class contains duplicated methods for better testing - isolating the setting of state from processing the stack
  attr_reader :receiver
  
  def initialize
    super
    @receiver ||= []
  end

  def set_state(char)
    add(char)
    @comment = true if comment_start
    @comment = false if comment_end
  end

  def process(char)
    add(char)
    @comment = true if comment_start
    @comment = false if comment_end
    c = filter
    @receiver << c unless c.nil?
    c unless c.nil?
  end
end

require 'test/unit'
require './test/test_helper.rb'

class QuackTest < Test::Unit::TestCase

  def setup
    @m = TestableManager.new
    @str = 'abcd/*efg*/hij'
    @foo = '/**/abc'
  end

  must "stringify top two elements of the stack when it contains at least 2 elements" do
    assert_equal @m.top_two, false
    @m.add 'a'
    assert_equal @m.top_two, false
    @m.add 'b'
    assert_equal @m.top_two, 'ab'
    @m.add 'c'
    assert_equal @m.top_two, 'bc'
  end

  must "set state correctly on common case (in-string comment)" do
    e = @str.each_char
    @m.set_state(e.next)
    assert_equal @m.comment, false #a
    @m.set_state(e.next)
    assert_equal @m.comment, false #b
    @m.set_state(e.next)
    assert_equal @m.comment, false #c
    @m.set_state(e.next)
    assert_equal @m.comment, false #d
    @m.set_state(e.next)
    assert_equal @m.comment, false #/
    @m.set_state(e.next)
    assert_equal @m.comment, true #*
    @m.set_state(e.next)
    assert_equal @m.comment, true #e
    @m.set_state(e.next)
    assert_equal @m.comment, true #f
    @m.set_state(e.next)
    assert_equal @m.comment, true #g
    @m.set_state(e.next)
    assert_equal @m.comment, true #*
    @m.set_state(e.next)
    assert_equal @m.comment, false #/
    @m.set_state(e.next)
    assert_equal @m.comment, false #h
  end

  must "set state correctly on edge case (leading empty comment)" do
    e = @foo.each_char

    @m.set_state(e.next)
    #p @m.quack
    assert_equal @m.length, 1
    assert_equal @m.top_two, false
    assert_equal @m.comment_start, false
    assert_equal @m.comment, false

    @m.set_state(e.next)
    #p @m.quack
    assert_equal @m.length, 2
    assert_equal @m.top_two, '/*'
    assert_equal @m.comment_start, true
    assert_equal @m.comment, true

    @m.set_state(e.next)
    #p @m.quack
    assert_equal @m.length, 3
    assert_equal @m.top_two, '**'
    assert_equal @m.comment_start, false
    assert_equal @m.comment, true

    @m.set_state(e.next)
    #p @m.quack
    assert_equal @m.length, 4
    assert_equal @m.top_two, '*/'
    assert_equal @m.comment_end, true
    assert_equal @m.comment, false

    @m.set_state(e.next)
    #p @m.quack
    assert_equal @m.length, 5
    assert_equal @m.top_two, '/a'
    assert_equal @m.comment_end, false
    assert_equal @m.comment, false
  end

  must "filter out comments on common case" do
    e = @str.each_char
    @m.process(e.next) #a
    assert_equal @m.quack, ["a"]
    @m.process(e.next) #b
    assert_equal @m.quack, ["a", "b"]
    @m.process(e.next) #c
    assert_equal @m.quack, ["b", "c"]
    @m.process(e.next) #d
    assert_equal @m.quack, ["c", "d"]
    @m.process(e.next) #/
    assert_equal @m.quack, ["d", "/"]
    @m.process(e.next) #*
    assert_equal @m.quack, ["/", "*"]
    @m.process(e.next) #e
    assert_equal @m.quack, ["/", "*", "e"]
    @m.process(e.next) #f
    assert_equal @m.quack, ["/", "*", "e", "f"]
    @m.process(e.next) #g
    assert_equal @m.quack, ["/", "*", "e", "f", "g"]
    @m.process(e.next) #*
    assert_equal @m.quack, ["/", "*", "e", "f", "g", "*"]
    @m.process(e.next) #/
    assert_equal @m.quack, []
    @m.process(e.next) #h
    assert_equal @m.quack, ["h"]
  end

  must "filter out comments on edge case" do
    e = @foo.each_char
    @m.process(e.next) #/
    assert_equal @m.quack, ["/"]
    @m.process(e.next) #*
    assert_equal @m.quack, ["/", "*"]
    @m.process(e.next) #*
    assert_equal @m.quack, ["/", "*", "*"]
    @m.process(e.next) #/
    assert_equal @m.quack, []
    @m.process(e.next) #a
    assert_equal @m.quack, ["a"]
  end

  must "filter out comments from input string and populate output array with correct characters" do
    e = 'div#foo {/*a comment*/border: 0;}'.each_char
    assert_equal @m.receiver, []
    @m.process(e.next) #d
    assert_equal @m.quack, ["d"]
    assert_equal @m.receiver, []

    @m.process(e.next) #i
    assert_equal @m.quack, ["d", "i"]
    assert_equal @m.receiver, []

    @m.process(e.next) #v
    assert_equal @m.quack, ["i", "v"]
    assert_equal @m.receiver, ["d"]

    @m.process(e.next) ##
    assert_equal @m.quack, ["v", "#"]
    assert_equal @m.receiver, ["d", "i"]

    @m.process(e.next) #f
    assert_equal @m.quack, ["#", "f"]
    assert_equal @m.receiver, ["d", "i", "v"]

    @m.process(e.next) #o
    assert_equal @m.quack, ["f", "o"]
    assert_equal @m.receiver, ["d", "i", "v", "#"]

    @m.process(e.next) #o
    assert_equal @m.quack, ["o", "o"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f"]

    @m.process(e.next) #' '
    assert_equal @m.quack, ["o", " "]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o"]

    @m.process(e.next) #'{'
    assert_equal @m.quack, [" ", "{"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o"]

    @m.process(e.next) #/
    assert_equal @m.quack, ["{", "/"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ']

    @m.process(e.next) #*
    assert_equal @m.quack, ["/", "*"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #a
    assert_equal @m.quack, ["/", "*", 'a']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #' '
    assert_equal @m.quack, ["/", "*", 'a', ' ']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #c
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #o
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #m
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o', 'm']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #m
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o', 'm', 'm']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #e
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o', 'm', 'm', 'e']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #n
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o', 'm', 'm', 'e', 'n']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #t
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o', 'm', 'm', 'e', 'n', 't']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #*
    assert_equal @m.quack, ["/", "*", 'a', ' ', 'c', 'o', 'm', 'm', 'e', 'n', 't', '*']
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #/
    assert_equal @m.quack, []
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #b
    assert_equal @m.quack, ["b"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #o
    assert_equal @m.quack, ["b", "o"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{"]

    @m.process(e.next) #r
    assert_equal @m.quack, ["o", "r"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b"]

    @m.process(e.next) #d
    assert_equal @m.quack, ["r", "d"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o"]

    @m.process(e.next) #e
    assert_equal @m.quack, ["d", "e"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r"]

    @m.process(e.next) #r
    assert_equal @m.quack, ["e", "r"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r", "d"]

    @m.process(e.next) #:
    assert_equal @m.quack, ["r", ":"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r", "d", "e"]

    @m.process(e.next) #' '
    assert_equal @m.quack, [":", " "]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r", "d", "e", "r"]

    @m.process(e.next) #0
    assert_equal @m.quack, [" ", "0"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r", "d", "e", "r", ":"]

    @m.process(e.next) #;
    assert_equal @m.quack, ["0", ";"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r", "d", "e", "r", ":", " "]

    @m.process(e.next) #}
    assert_equal @m.quack, [";", "}"]
    assert_equal @m.receiver, ["d", "i", "v", "#", "f", "o", "o", ' ', "{", "b", "o", "r", "d", "e", "r", ":", " ", "0"]
  end

end