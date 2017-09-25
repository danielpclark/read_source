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

AlsoAttrMethodName = %Q{define_method(:also_attr_method_name){ "asdf" }\n}

class SameFile
  attr_writer :a
  attr_name = :attr_thingy
  define_method("#{attr_name}=") do |value|
    ivar = "@#{attr_name.to_s}"
    tell_si ivar, instance_variable_get(ivar), value 

    instance_variable_set(ivar, value)
  end
end


class ReadSourceTest < Minitest::Test
  def test_it_gets_attr_from_same_file
    assert_equal :attr_writer,
      SameFile.instance_method(:a=).attr?
  end

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
      %Q{define_method(:also_attr_method_name){ "asdf" }\n}
  end

  def test_it_handles_special_define_method_attr
    refute SameFile.instance_method(:attr_thingy=).attr?
    assert SameFile.instance_method(:attr_thingy=).read_source
  end
end
