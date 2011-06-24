require '../lib/manager.rb'
require 'test/unit'
require '../test/test_helper.rb'

class ManagerTest < Test::Unit::TestCase

  def setup
    @m = Manager.new
  end

  def remove_comments_from_css_string
    result = ""
    testfile.each_char do |c|
      c = @m.process c
      result << c unless c.nil?
    end
    2.times {result << @m.get_first}
    result
  end

  def test_remove_comments_from_css_string
    assert_equal remove_comments_from_css_string, uncommented_testfile
  end
  
  def testfile
    "
    /*comment*/
    /*another comment*/

    /*concatenated*//*comment*/

    @import 'somefile.css';

    * {margin: 0; padding: 0;}

    body {
        /*
        multi-line
        comment
        */
        background: #fff;
        font-size: 62%; /*inline comment*/
    }

    div#container {/*inline comment*/border: 0; /*trailing comment*/}

    #foo{}/*closing comment*/

    /*also a comment*/#bar{}

    /*final comment*/

    div#container {/*inline comment*/border: 0;}
    ".gsub!(/\n/, '').gsub!(" ", '')
  end
    
  def uncommented_testfile
    "
    @import 'somefile.css';

    * {margin: 0; padding: 0;}

    body {
        background: #fff;
        font-size: 62%;
    }

    div#container {border: 0; }

    #foo{}

    #bar{}

    div#container {border: 0;}
    ".gsub!(/\n/, '').gsub!(" ", '')
  end

end

