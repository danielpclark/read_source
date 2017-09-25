class Example
  attr :a
  attr_reader :b
  attr_accessor :c
  attr_writer :d
  def f; nil end
  def f= _; nil end
  def apple
    "Johny Apple Seed was here"
  end

  def inline_method; "asdf" end

  def attr_method_name
    "asdf"
  end

  define_method(:also_attr_method_name){ "asdf" }

  define_method(:attr_again) do
    "asdf"
  end

  define_method :johny, instance_method(:apple)
end
