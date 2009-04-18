module GitStyleBinary
class Parser < Trollop::Parser

  def educate stream=$stdout
    super
  end

  def consume(&block)
    cloaker(&block).bind(self).call
  end
 
end
end
