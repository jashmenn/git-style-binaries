class Object
  # ruby 1.8.6 backport of tap
  def tap
    yield(self)
    self
  end unless Object.respond_to?(:tap)
end

class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end

class IO
  attr_accessor :use_color
end
