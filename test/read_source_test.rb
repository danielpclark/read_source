require 'minitest_helper'
require_relative 'support/example'

Apple = %Q{def apple
  "Johny Apple Seed was here"
end
}

class ReadSourceTest < Minitest::Test
  def test_it_reads_source
    assert_equal Apple,
      Example.instance_method(:apple).read_source
  end

  def test_it_returns_correct_attr_type
    assert_equal :attr,
      Example.instance_method(:a).attr?
    assert_equal :attr_reader,
      Example.instance_method(:b).attr?
    assert_equal :attr_accessor,
      Example.instance_method(:c).attr?
    assert_equal :attr_accessor,
      Example.instance_method(:c=).attr?
    assert_equal :attr_writer,
      Example.instance_method(:d=).attr?
    refute Example.instance_method(:f).attr?
    refute Example.instance_method(:f=).attr?
  end

  def test_attr_returns_nil_on_method
    refute Example.instance_method(:apple).attr?
  end

  def test_read_source_doesnt_read_past_attr
    assert_equal Example.instance_method(:a).read_source,
      "attr :a\n"
  end
end
