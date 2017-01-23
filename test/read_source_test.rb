require 'minitest_helper'
require_relative 'support/example'

Apple = %Q{def apple
  "Johny Apple Seed was here"
end
}

AttrMethodName = %Q{def attr_method_name
  "asdf"
end
}

AlsoAttrMethodName = %Q{define_method :also_attr_method_name { "asdf" }\n}

class ReadSourceTest < Minitest::Test
  def test_it_reads_source
    assert_equal Apple,
      Example.instance_method(:apple).read_source
    assert_equal AttrMethodName,
      Example.instance_method(:attr_method_name).read_source
    assert_equal AlsoAttrMethodName,
      Example.instance_method(:also_attr_method_name).read_source
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
    refute Example.instance_method(:attr_method_name).attr?
    refute Example.instance_method(:also_attr_method_name).attr?
  end

  def test_attr_returns_nil_on_method
    refute Example.instance_method(:apple).attr?
  end

  def test_read_source_doesnt_read_past_attr
    assert_equal Example.instance_method(:a).read_source,
      "attr :a\n"
  end

  def test_read_source_handles_inline_methods
    assert_equal Example.instance_method(:inline_method).read_source,
      %Q{def inline_method; "asdf" end\n}
    assert_equal Example.instance_method(:also_attr_method_name).read_source,
      %Q{define_method :also_attr_method_name { "asdf" }\n}
  end
end
